import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

import 'chat_data.dart';
import 'chat_item_values.dart';
import 'chat_ticker_value.dart';

part 'stored_chat_data.g.dart';

@collection
class StoredChatItem {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String source;

  @Index(type: IndexType.value)
  late int index;

  @Index(type: IndexType.value)
  late int timestamp;

  String? itemId;

  String? authorId;

  late String itemJsonString;
}

@collection
class StoredChatTicker {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String source;

  @Index(type: IndexType.value)
  late int index;

  @Index(type: IndexType.value)
  late int timestamp;

  @Index(type: IndexType.value)
  late int endTimestamp;

  String? authorId;

  late String tickerJsonString;
}

class StoredChatData implements ChatData {
  StoredChatData({
    required this.db,
    required this.source,
    required this.itemCount,
    required this.tickerCount,
    required this.timestampRange,
    required this.zeroTimestamp,
  });

  final Isar db;
  final String source;

  @override
  final int itemCount;
  @override
  final int tickerCount;
  @override
  final IntRange timestampRange;
  @override
  final int zeroTimestamp;

  static Future<StoredChatData?> fromRawJsonStream({
    required Stream<Map<String, dynamic>> jsonStream,
    required String dbPath,
    required String source,
    Logger? logger,
    void Function(ChatMetadata metadata)? onProgress,
  }) async {
    final db = Isar.getInstance("chat_data") ??
        await Isar.open(
          [StoredChatItemSchema, StoredChatTickerSchema],
          directory: dbPath,
          name: "chat_data",
        );

    await db.writeTxn(() async {
      await db.clear();
    });

    final finalMetadata = await db.writeTxn(() async {
      return await ChatData.forEachInRawJson(
        jsonStream,
        logger: logger,
        onProgress: onProgress,
        itemAction: (item, itemJson, index) {
          final cachedItem = StoredChatItem()
            ..source = source
            ..index = index
            ..timestamp = item.timestamp
            ..itemJsonString = jsonEncode(itemJson);

          if (item is AuthoredChatItemValue) {
            cachedItem.authorId = item.author.channelId;
            cachedItem.itemId = item.id;
          }

          db.storedChatItems.put(cachedItem);
        },
        tickerAction: (ticker, tickerJson, index) {
          final cachedTicker = StoredChatTicker()
            ..source = source
            ..index = index
            ..timestamp = ticker.timestamp
            ..endTimestamp = ticker.endTimestamp
            ..tickerJsonString = jsonEncode(tickerJson)
            ..authorId = ticker.author.channelId;

          db.storedChatTickers.put(cachedTicker);
        },
      );
    });

    if (finalMetadata == null) return null;

    return StoredChatData(
      db: db,
      source: source,
      itemCount: finalMetadata.itemCount,
      tickerCount: finalMetadata.tickerCount,
      timestampRange: finalMetadata.timestampRange,
      zeroTimestamp: finalMetadata.zeroTimestamp,
    );
  }

  @override
  Future<List<ChatTickerValue>> ongoingTickersAt(int timestamp) async {
    final query = db.storedChatTickers
        .where()
        .timestampLessThan(timestamp, include: true) // also sorts by timestamp
        .filter()
        .sourceEqualTo(source)
        .endTimestampGreaterThan(timestamp);

    final storedTickers = await query.findAll();

    return storedTickers.mapNotNull((cachedTicker) {
      final tickerJson = jsonDecode(cachedTicker.tickerJsonString);
      return ChatTickerValue.fromRendererJson(tickerJson);
    }).toList();
  }

  @override
  Future<List<ChatItemValue>> lastItemsAt(
    int timestamp, {
    required int limit,
    int offset = 0,
  }) async {
    final query = db.storedChatItems
        .where(sort: Sort.desc)
        .anyIndex() // to sort by index (insertion order)
        .filter()
        .sourceEqualTo(source)
        .timestampLessThan(timestamp, include: true)
        .sortByTimestampDesc() // to sort by timestamp (message time)
        .offset(offset)
        .limit(limit);

    final storedItems = await query.findAll();

    return storedItems.mapNotNull((cachedItem) {
      final itemJson = jsonDecode(cachedItem.itemJsonString);
      return ChatItemValue.fromJson(itemJson);
    }).toList();
  }

  @override
  Future<void> dispose() async {
    await db.writeTxn(() async {
      await db.storedChatItems.where().sourceEqualTo(source).deleteAll();
      await db.storedChatTickers.where().sourceEqualTo(source).deleteAll();
    });
  }
}
