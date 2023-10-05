import 'package:dartx/dartx.dart';
import 'package:logger/logger.dart';

import 'chat_item_values.dart';
import 'chat_ticker_value.dart';

class ChatMetadata {
  ChatMetadata({
    required this.itemCount,
    required this.tickerCount,
    required this.timestampRange,
    required this.zeroTimestamp,
  });

  final int itemCount;
  final int tickerCount;
  final IntRange timestampRange;
  final int zeroTimestamp;
}

abstract class ChatData implements ChatMetadata {

  /// list of tickers that are active at specified [timestamp], 
  /// in chronological order.
  Future<List<ChatTickerValue>> ongoingTickersAt(int timestamp);

  /// list of items starting at [timestamp] and going backwards until [limit],
  /// taking [offset] into account.
  Future<List<ChatItemValue>> lastItemsAt(
    int timestamp, {
    required int limit,
    required int offset,
  });

  // TODO LiveChatActionPanel? actionPanelAt(int timestamp);

  // TODO search for text/users in items
  
  // TODO Future<Image> getImage(String url);

  /// Discards any resources used by the object.
  /// After this is called,
  /// the object is not in a usable state and should be discarded.
  Future<void> dispose();

  static Future<ChatMetadata?> forEachInRawJson(
    Stream<Map<String, dynamic>> jsonStream, {
    Logger? logger,
    void Function(ChatMetadata metadata)? onProgress,
    void Function(
      ChatItemValue item,
      Map<String, dynamic> itemJson,
      int index,
    )? itemAction,
    void Function(
      ChatTickerValue ticker,
      Map<String, dynamic> tickerJson,
      int index,
    )? tickerAction,
  }) async {
    // TODO make this configurable
    const blacklistedChatItems = ["liveChatPlaceholderItemRenderer"];

    final actionsStream = jsonStream.map((json) {
      // for some reason, offset can appear at multiple places
      String? offset1 = json['replayChatItemAction']?['videoOffsetTimeMsec'];
      String? offset2 = json['videoOffsetTimeMsec'];
      final offset = offset1?.toIntOrNull() ?? offset2?.toIntOrNull();

      final actions = json["replayChatItemAction"]?["actions"] as List?;

      if (offset == null || actions == null) {
        logger?.d("Can't parse chat replay: $json");
        return null;
      }

      return (offset * 1000, actions);
    }).expand<(int, Map<String, dynamic>)>((actionsAtOffset) {
      if (actionsAtOffset == null) return const [];
      final (offset, actions) = actionsAtOffset;
      return actions.map((e) => (offset, e as Map<String, dynamic>));
    });

    // TODO calculate money received?
    // TODO histogram?
    int itemCount = 0;
    int tickerCount = 0;
    int? startTimestamp;
    int? endTimestamp;
    int? videoStartTimestamp;
    await for (final actionAtOffset in actionsStream) {
      final (offset, action) = actionAtOffset;

      // items
      if (action.containsKey('addChatItemAction')) {
        final chatItemJson = action['addChatItemAction']?['item'];
        // json not json
        if (chatItemJson is! Map<String, dynamic>) {
          logger?.d("Can't parse chat item as json: $chatItemJson");
          continue;
        }
        // skip irrelevant items
        if (chatItemJson.keys.containsAny(blacklistedChatItems)) continue;

        final chatItem = ChatItemValue.fromJson(chatItemJson);

        if (chatItem == null) {
          logger?.d("Can't parse chat item: $chatItemJson");
          continue;
        }

        itemAction?.invoke(chatItem, chatItemJson, itemCount);
        itemCount++;

        // remember earliest timestamps
        if (startTimestamp == null || chatItem.timestamp < startTimestamp) {
          startTimestamp = chatItem.timestamp;
        }
        // remember latest timestamp
        // offset 0 is ignored because some items have weird timestamps
        if (offset != 0 &&
            (endTimestamp == null || chatItem.timestamp > endTimestamp)) {
          endTimestamp = chatItem.timestamp;
        }

        // calculate video start timestamp.
        // this isn't included in the json stream, and calculations might be
        // inaccurate (mainly at offset=0)
        if (videoStartTimestamp == null && offset != 0) {
          videoStartTimestamp = chatItem.timestamp - offset;
        }
      }
      // item deleted
      else if (action.containsKey('removeChatItemAction')) {
        // TODO deleted items
        // onItemDeleted?.invoke()?
      }
      // tickers
      else if (action.containsKey('addLiveChatTickerItemAction')) {
        final json = action['addLiveChatTickerItemAction']?['item'];
        final tickerJson = json?['liveChatTickerSponsorItemRenderer'] ??
            json?['liveChatTickerPaidMessageItemRenderer'] ??
            json?['liveChatTickerPaidStickerItemRenderer'];

        // json not json
        if (tickerJson is! Map<String, dynamic>) {
          logger?.d("Can't parse ticker as json: $tickerJson");
          continue;
        }

        final ticker = ChatTickerValue.fromRendererJson(tickerJson);

        if (ticker == null) {
          logger?.d("Can't parse ticker: $json");
          continue;
        }

        tickerAction?.invoke(ticker, tickerJson, tickerCount);
        tickerCount++;

        // TODO detect minimum amount to pin message?
        // (not all paid messages get pinned as tickers, 
        //  only when purchange amount is above a threshold set by creator)
      } else {
        logger?.d("Can't parse action: $action");
      }

      if (startTimestamp != null) {
        onProgress?.invoke(
          ChatMetadata(
            itemCount: itemCount,
            tickerCount: tickerCount,
            timestampRange: IntRange(
              startTimestamp,
              endTimestamp ?? startTimestamp,
            ),
            zeroTimestamp: videoStartTimestamp ?? startTimestamp,
          ),
        );
      }
    }

    if (startTimestamp == null) return null;

    return ChatMetadata(
      itemCount: itemCount,
      tickerCount: tickerCount,
      timestampRange: IntRange(
        startTimestamp,
        endTimestamp ?? startTimestamp,
      ),
      zeroTimestamp: videoStartTimestamp ?? startTimestamp,
    );
  }
}
