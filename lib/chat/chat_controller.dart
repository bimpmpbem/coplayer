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
    required this.source,
    this.logger,
    this.cachedItemCount = 100,
    this.updateFrequency = const Duration(milliseconds: 200),
    this.inMemory = false,
  }) : super();

  final Logger? logger;

  ChatMetadata? chatData;

  final XFile source;
  final Duration updateFrequency;

  final int cachedItemCount;

  bool inMemory;

  // TODO add ignoreBuffering to control if should pause when buffering?

  Timer? _timer;
  bool _initializing = false;
  bool _disposed = false;

  @override
  Future<Duration?> get position async => value.estimatedPosition;

  /// timestamp matching the current [value.estimatedPosition]
  int get currentEstimatedTimestamp =>
      (chatData?.zeroTimestamp ?? 0) + value.estimatedPosition.inMicroseconds;

  @override
  Future<void> initialize() async {
    if (value.playState.value != PlayState.uninitialized ||
        _disposed ||
        _initializing) return;

    _initializing = true;

    final size = await source.length();
    int parsedBytes = 0;
    final jsonStream = source
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

    GenericPlayerState valueWithPositionFrom(
      GenericPlayerState value,
      ChatMetadata metadata,
    ) {
      final timestampRange = metadata.timestampRange;
      final zeroTimestamp = metadata.zeroTimestamp;
      final actualRange = DurationRange(
        Duration(microseconds: timestampRange.start - zeroTimestamp),
        Duration(microseconds: timestampRange.endInclusive - zeroTimestamp),
      );
      return value.copyWith(
        positionRange: actualRange,
        position: Duration.zero.clampToRange(actualRange),
      );
    }

    void updateLoadState(ChatMetadata metadata) {
      if (_disposed) return;
      chatData = ChatLoadMetadata(
        itemCount: metadata.itemCount,
        tickerCount: metadata.tickerCount,
        timestampRange: metadata.timestampRange,
        zeroTimestamp: metadata.zeroTimestamp,
        loadedBytes: parsedBytes,
        totalBytes: size,
      );
      final newValue = valueWithPositionFrom(value, metadata);
      value = newValue;
      notifyListeners(); // might not be needed
    }

    ChatData? newChatData;
    try {
      newChatData = (inMemory || kIsWeb) // database doesn't support web
          ? await MemoryChatData.fromRawJsonStream(
              jsonStream,
              onProgress: updateLoadState,
              logger: logger,
            )
          : await StoredChatData.fromRawJsonStream(
              jsonStream: jsonStream,
              dbPath: (await getTemporaryDirectory()).path,
              source: source.path.isNotBlank ? source.path : source.name,
              onProgress: updateLoadState,
              logger: logger,
            );
    } on FormatException catch (_) {
      // bad file
    }

    if (_disposed) return; // controller might be disposed of while parsing file

    if (newChatData == null) {
      value = value.copyWith(errorDescription: "Initialization failed.");
      return;
    }

    chatData = newChatData;
    value = valueWithPositionFrom(value, newChatData).copyWith(
      playState: PlayState.paused,
    );
    _initializing = false;
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;

    _disposed = true;

    _timer?.cancel();
    _timer = null;

    final chatData = this.chatData;
    if (chatData is ChatData) await chatData.dispose();
    this.chatData = null;

    return super.dispose();
  }

  @override
  Future<void> play() async {
    if (value.playState.value != PlayState.paused || _disposed) return;

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
    if (_disposed) return;

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
    final chatData = this.chatData;
    if (chatData is! ChatData) return Future.value(const []);

    return chatData.lastItemsAt(
      currentEstimatedTimestamp,
      limit: limit,
      offset: offset,
    );
  }

  /// currently ongoing tickers.
  Future<List<ChatTickerValue>> getOngoingTickers() {
    final chatData = this.chatData;
    if (chatData is! ChatData) return Future.value(const []);

    final timestamp = currentEstimatedTimestamp;

    return chatData.ongoingTickersAt(timestamp);
  }

  @override
  Future<void> setPosition(Duration position) async {
    if (_disposed) return;

    value = value.copyWith(
      position: position.clampToRange(value.positionRange.value),
    );
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    if (_disposed) return;

    value = value.copyWith(
      playbackSpeed: speed,
      position: value.estimatedPosition,
    );
  }
}
