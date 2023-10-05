import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';

import 'chat_author_value.dart';
import 'chat_image_value.dart';
import 'chat_item_values.dart';

// TODO maybe split this up to 3 different tickers:
// - liveChatTickerPaidMessageItemRenderer
// - liveChatTickerSponsorItemRenderer
// - liveChatTickerPaidStickerItemRenderer
class ChatTickerValue extends Equatable {
  const ChatTickerValue({
    required this.id,
    required this.startBackgroundColor,
    required this.endBackgroundColor,
    required this.detailTextColor,
    required this.detailTextJson,
    required this.thumbnails,
    required this.author,
    required this.durationSec,
    required this.fullDurationSec,
    required this.itemJson,
    required this.timestamp,
  });

  final int timestamp;
  final String id;
  final int startBackgroundColor;
  final int endBackgroundColor;
  final int? detailTextColor;
  final Map<String, dynamic>? detailTextJson; // usually either details,
  final List<ChatImageValue> thumbnails; // or thumbnails, not both.
  final ChatAuthorValue author;
  final int durationSec;
  final int fullDurationSec;
  final Map<String, dynamic> itemJson;

  int get endTimestamp => timestamp + (durationSec * 1000000);

  @override
  List<Object?> get props => [
        id,
        startBackgroundColor,
        endBackgroundColor,
        detailTextColor,
        detailTextJson,
        thumbnails,
        author,
        durationSec,
        fullDurationSec,
        itemJson,
        timestamp,
      ];

  @override
  bool? get stringify => true;

  static ChatTickerValue? fromRendererJson(Map<String, dynamic> json) {
    try {
      final itemJson =
          json["showItemEndpoint"]?["showLiveChatItemEndpoint"]?["renderer"];

      // ticker does not contain some values, has to be extracted from item
      final item = ChatItemValue.fromJson(itemJson);

      if (item is! AuthoredChatItemValue) return null;

      final thumbnails = (json["tickerThumbnails"] as List<dynamic>?)
          ?.mapNotNull((thumnailJson) {
        if (thumnailJson is! Map<String, dynamic>) return null;
        return ChatImageValue.fromJson(json);
      }).toList() ?? [];

      return ChatTickerValue(
        timestamp: item.timestamp,
        id: json["id"],
        startBackgroundColor: json["startBackgroundColor"],
        endBackgroundColor: json["endBackgroundColor"],
        detailTextColor: json["detailTextColor"] ?? json["amountTextColor"],
        thumbnails: thumbnails,
        detailTextJson: json["detailText"],
        author: item.author,
        durationSec: json["durationSec"],
        fullDurationSec: json["fullDurationSec"],
        itemJson: itemJson,
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}
