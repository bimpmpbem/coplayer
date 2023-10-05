import 'dart:async';
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:dartx/dartx.dart';
import 'package:dartx/dartx_io.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../duration_range.dart';
import '../generic_player_controller.dart';
import '../generic_player_state.dart';
import 'data/chat_data.dart';
import 'data/chat_item_values.dart';
import 'data/chat_ticker_value.dart';
import 'data/memory_chat_data.dart';
import 'data/stored_chat_data.dart';

/// A controller for a chat player.
class ChatController extends GenericPlayerController {
  ChatController({
    required this.chatData,
    this.cachedItemCount = 100,
    this.updateFrequency = const Duration(milliseconds: 200),
  });

  static Future<ChatController?> parseFile(
    XFile file, {
    Logger? logger,
    void Function(
      ChatMetadata metadata,
      int parsedBytes,
      int totalBytes,
    )? onProgress,
    bool inMemory = false,
  }) async {
    final size = await file.length();
    int parsedBytes = 0;

    final jsonStream = file
        .openRead()
        .transform(StreamTransformer<Uint8List, List<int>>.fromHandlers(
          handleData: (Uint8List value, EventSink<List<int>> sink) {
            // there's probably be a better way to count bytes
            sink.add(value);
            parsedBytes += value.length;
          },
        ))
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .map((line) => jsonDecode(line) as Map<String, dynamic>);

    ChatData? chatData;
    try {
      chatData = (inMemory || kIsWeb) // database doesn't support web
          ? await MemoryChatData.fromRawJsonStream(
              jsonStream,
              onProgress: (metadata) {
                onProgress?.invoke(metadata, parsedBytes, size);
              },
              logger: logger,
            )
          : chatData = await StoredChatData.fromRawJsonStream(
              jsonStream: jsonStream,
              dbPath: (await getTemporaryDirectory()).path,
              source: file.path.isNotBlank ? file.path : file.name,
              onProgress: (metadata) {
                onProgress?.invoke(metadata, parsedBytes, size);
              },
              logger: logger,
            );
    } on FormatException catch (_) {
      // bad file
    }

    if (chatData == null) return null;

    return ChatController(chatData: chatData);
  }

  final ChatData chatData;
  final Duration updateFrequency;

  final int cachedItemCount;

  // TODO add ignoreBuffering to control if should pause when buffering?

  Timer? _timer;

  @override
  Future<Duration?> get position async => value.estimatedPosition;

  /// timestamp matching the current [value.estimatedPosition]
  int get currentEstimatedTimestamp =>
      chatData.zeroTimestamp + value.estimatedPosition.inMicroseconds;

  @override
  Future<void> initialize() async {
    if (value.playState.value != PlayState.uninitialized) return;

    final rawRange = chatData.timestampRange;
    final zeroTimestamp = chatData.zeroTimestamp;
    value = value.copyWith(
      playState: PlayState.paused,
      positionRange: DurationRange(
        Duration(microseconds: chatData.timestampRange.start - zeroTimestamp),
        Duration(microseconds: rawRange.endInclusive - zeroTimestamp),
      ),
      position: Duration.zero,
    );
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    await chatData.dispose();
    return super.dispose();
  }

  @override
  Future<void> play() async {
    if (value.playState.value != PlayState.paused) return;

    value = value.copyWith(
      playState: PlayState.playing,
      position: value.position.value,
    );

    _timer?.cancel();
    _timer = Timer.periodic(
      updateFrequency,
      (timer) {
        if (value.estimatedPosition == value.positionRange.value.endInclusive) {
          pause();
          return;
        }

        value = value.copyWith(
          position: value.estimatedPosition,
        );
      },
    );
  }

  @override
  Future<void> pause() async {
    _timer?.cancel();
    _timer = null;

    if (value.playState.value != PlayState.playing &&
        value.playState.value != PlayState.playingBuffering) {
      return;
    }

    value = value.copyWith(
      playState: PlayState.paused,
      position: value.estimatedPosition,
    );
  }

  /// last items at current time, in reverse order.
  // using buffer, maybe replace this method with getLastItem(offset)
  // and dynamically cache per item
  Future<List<ChatItemValue>> getLastItems({
    int limit = 100,
    int offset = 0,
  }) {
    return chatData.lastItemsAt(
      currentEstimatedTimestamp,
      limit: limit,
      offset: offset,
    );
  }

  /// currently ongoing tickers.
  Future<List<ChatTickerValue>> getOngoingTickers() {
    final timestamp = currentEstimatedTimestamp;

    return chatData.ongoingTickersAt(timestamp);
  }

  @override
  Future<void> setPosition(Duration position) async {
    value = value.copyWith(
      position: position.clampToRange(value.positionRange.value),
    );
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    value = value.copyWith(
      playbackSpeed: speed,
      position: value.estimatedPosition,
    );
  }
}
