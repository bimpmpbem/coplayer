import 'package:dartx/dartx.dart';
import 'package:logger/logger.dart';

import 'chat_data.dart';
import 'chat_item_values.dart';
import 'chat_ticker_value.dart';

class StoredChatData implements ChatData {
  static Future<StoredChatData?> fromRawJsonStream({
    required Stream<Map<String, dynamic>> jsonStream,
    required String dbPath,
    required String source,
    Logger? logger,
    void Function(ChatMetadata metadata)? onProgress,
  }) =>
      throw UnsupportedError("StoredChatData is unsupported in this platform");

  @override
  Future<void> dispose() {
    throw UnsupportedError("StoredChatData is unsupported in this platform");
  }

  @override
  int get itemCount =>
      throw UnsupportedError("StoredChatData is unsupported in this platform");

  @override
  Future<List<ChatItemValue>> lastItemsAt(int timestamp,
      {required int limit, required int offset}) {
    throw UnsupportedError("StoredChatData is unsupported in this platform");
  }

  @override
  Future<List<ChatTickerValue>> ongoingTickersAt(int timestamp) {
    throw UnsupportedError("StoredChatData is unsupported in this platform");
  }

  @override
  int get tickerCount =>
      throw UnsupportedError("StoredChatData is unsupported in this platform");

  @override
  IntRange get timestampRange =>
      throw UnsupportedError("StoredChatData is unsupported in this platform");

  @override
  int get zeroTimestamp =>
      throw UnsupportedError("StoredChatData is unsupported in this platform");
}
