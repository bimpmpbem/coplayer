import 'package:dartx/dartx.dart';
import 'package:logger/logger.dart';

import 'chat_data.dart';
import 'chat_item_values.dart';
import 'chat_ticker_value.dart';

class MemoryChatData implements ChatData {
  MemoryChatData({
    required this.items,
    required this.tickers,
    required this.timestampRange,
    required this.zeroTimestamp,
  });

  final List<ChatItemValue> items;
  final List<ChatTickerValue> tickers;
  @override
  final IntRange timestampRange;
  @override
  final int zeroTimestamp;

  static Future<MemoryChatData?> fromRawJsonStream(
    Stream<Map<String, dynamic>> jsonStream, {
    Logger? logger,
    void Function(ChatMetadata metadata)? onProgress,
  }) async {
    final chatItems = <ChatItemValue>[];
    final chatTickers = <ChatTickerValue>[];
    final finalMetadata = await ChatData.forEachInRawJson(
      jsonStream,
      logger: logger,
      onProgress: onProgress,
      itemAction: (item, _, __) => chatItems.add(item),
      tickerAction: (ticker, _, __) => chatTickers.add(ticker),
    );

    if (finalMetadata == null) return null;

    return MemoryChatData(
      items: chatItems,
      tickers: chatTickers,
      timestampRange: finalMetadata.timestampRange,
      zeroTimestamp: finalMetadata.zeroTimestamp,
    );
  }

  @override
  int get itemCount => items.length;

  @override
  int get tickerCount => tickers.length;

  @override
  Future<List<ChatTickerValue>> ongoingTickersAt(int timestamp) async {
    return tickers.whereIndexed((ticker, index) {
      return timestamp.inRange(IntRange(ticker.timestamp, ticker.endTimestamp));
    }).toList();
  }

  @override
  Future<List<ChatItemValue>> lastItemsAt(
    int timestamp, {
    required int limit,
    int offset = 0,
  }) async {
    if (items.isEmpty) return [];

    final (lastIndex, _) = items.indexed.reduce((best, current) {
      final (_, currentValue) = current;
      final (_, bestValue) = best;

      final currentDelta = timestamp - currentValue.timestamp;
      final besetDelta = (timestamp - bestValue.timestamp).abs();
      if (currentDelta >= 0 && currentDelta < besetDelta) {
        return current;
      } else {
        return best;
      }
    });

    final end = (lastIndex + offset).clamp(0, items.lastIndex);
    final start = (end - limit).clamp(0, items.lastIndex);

    return items.sublist(start, end).reversed.toList();
  }

  @override
  Future<void> dispose() async {
    items.clear();
    tickers.clear();
  }
}
