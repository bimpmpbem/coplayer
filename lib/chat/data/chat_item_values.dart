import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';

import '../widgets/chat_text.dart';
import 'chat_author_value.dart';
import 'chat_image_value.dart';

class ChatItemValue extends Equatable {
  const ChatItemValue({required this.timestamp});

  /// microseconds
  // TODO replace with DateTime?
  final int timestamp;

  @override
  List<Object?> get props => [timestamp];

  static ChatItemValue? fromJson(Map<String, dynamic> json) {
    for (final entry in jsonConstructors.entries) {
      if (json.containsKey(entry.key)) {
        return entry.value(json[entry.key]);
      }
    }
    return null;
  }

  static const jsonConstructors = {
    'liveChatModeChangeMessageRenderer':
        ChatModeChangeMessageValue.fromRendererJson,
    'liveChatViewerEngagementMessageRenderer':
        ChatViewerEngagementMessageValue.fromRendererJson,
    'liveChatTextMessageRenderer': ChatTextMessageValue.fromRendererJson,
    'liveChatPaidMessageRenderer': ChatPaidMessageValue.fromRendererJson,
    'liveChatMembershipItemRenderer': ChatMembershipValue.fromRendererJson,
    'liveChatPaidStickerRenderer': ChatStickerValue.fromRendererJson,
  };
}

class ChatModeChangeMessageValue extends ChatItemValue {
  const ChatModeChangeMessageValue({
    required super.timestamp,
    required this.iconType,
    required this.textJson,
    required this.subtextJson,
    required this.timestampText,
  });

  final String iconType;
  final Map<String, dynamic> textJson;
  final Map<String, dynamic> subtextJson;
  final String timestampText;

  @override
  List<Object?> get props => [
        timestamp,
        iconType,
        textJson,
        subtextJson,
        timestampText,
      ];

  static ChatModeChangeMessageValue? fromRendererJson(
      Map<String, dynamic> json) {
    try {
      return ChatModeChangeMessageValue(
        timestamp: (json["timestampUsec"] as String).toInt(),
        iconType: json["icon"]?["iconType"],
        textJson: json["text"],
        subtextJson: json["subtext"],
        timestampText: json["timestampText"]?["simpleText"],
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}

class ChatViewerEngagementMessageValue extends ChatItemValue {
  const ChatViewerEngagementMessageValue({
    required super.timestamp,
    required this.iconType,
    required this.messageJson,
  });

  final String iconType;
  final Map<String, dynamic> messageJson;

  @override
  List<Object?> get props => [timestamp, iconType, messageJson];

  static ChatViewerEngagementMessageValue? fromRendererJson(
      Map<String, dynamic> json) {
    try {
      return ChatViewerEngagementMessageValue(
        timestamp: (json["timestampUsec"] as String).toInt(),
        iconType: json["icon"]?["iconType"],
        messageJson: json["message"],
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}

// TODO change to mixin?
class AuthoredChatItemValue extends ChatItemValue {
  const AuthoredChatItemValue({
    required super.timestamp,
    required this.author,
    required this.id,
    required this.timestampText,
  });

  final ChatAuthorValue author;
  final String id;
  final String? timestampText;

  @override
  List<Object?> get props => [
        timestamp,
        author,
        id,
        timestampText,
      ];
}

class ChatTextMessageValue extends AuthoredChatItemValue {
  const ChatTextMessageValue({
    required super.timestamp,
    required super.author,
    required super.id,
    required super.timestampText,
    required this.messageJson,
    required this.simplifiedMessage,
  });

  final Map<String, dynamic>? messageJson;
  final String simplifiedMessage;

  @override
  List<Object?> get props => [
        timestamp,
        author,
        id,
        timestampText,
        messageJson,
        simplifiedMessage,
      ];

  static ChatTextMessageValue? fromRendererJson(Map<String, dynamic> json) {
    try {
      final author = ChatAuthorValue.fromRendererJson(json);
      if (author == null) return null;
      return ChatTextMessageValue(
        timestamp: (json["timestampUsec"] as String).toInt(),
        messageJson: json["message"],
        simplifiedMessage: ChatText.messageJsonToString(json["message"]),
        author: author,
        id: json["id"],
        timestampText: json["timestampText"]?["simpleText"],
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}

class ChatPaidMessageValue extends ChatTextMessageValue {
  const ChatPaidMessageValue({
    required super.timestamp,
    required super.author,
    required super.id,
    required super.timestampText,
    required super.messageJson,
    required super.simplifiedMessage,
    required this.purchaseAmount,
    required this.headerBackgroundColor,
    required this.bodyBackgroundColor,
  });

  final String purchaseAmount;
  final int headerBackgroundColor;
  final int bodyBackgroundColor;
  // final int headerTextColor;
  // final int bodyTextColor;
  // final int timestampColor;

  @override
  List<Object?> get props => [
        timestamp,
        author,
        id,
        timestampText,
        messageJson,
        simplifiedMessage,
        purchaseAmount,
        headerBackgroundColor,
        bodyBackgroundColor,
      ];

  static ChatPaidMessageValue? fromRendererJson(Map<String, dynamic> json) {
    try {
      final author = ChatAuthorValue.fromRendererJson(json);
      if (author == null) return null;
      return ChatPaidMessageValue(
        timestamp: (json["timestampUsec"] as String).toInt(),
        messageJson: json["message"],
        simplifiedMessage:
            ChatText.messageJsonToString(json["message"] ?? const {}),
        author: author,
        id: json["id"],
        timestampText: json["timestampText"]?["simpleText"],
        purchaseAmount: json["purchaseAmountText"]?["simpleText"],
        headerBackgroundColor: json["headerBackgroundColor"],
        bodyBackgroundColor: json["bodyBackgroundColor"],
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}

class ChatMembershipValue extends ChatTextMessageValue {
  const ChatMembershipValue({
    required super.timestamp,
    required super.author,
    required super.id,
    required super.timestampText,
    required super.messageJson,
    required super.simplifiedMessage,
    required this.headerTextJson,
    required this.headerSubtextJson,
  });

  final Map<String, dynamic>? headerTextJson;
  final Map<String, dynamic> headerSubtextJson;

  @override
  List<Object?> get props => [
        timestamp,
        author,
        id,
        timestampText,
        messageJson,
        simplifiedMessage,
        headerSubtextJson,
      ];

  static ChatMembershipValue? fromRendererJson(Map<String, dynamic> json) {
    try {
      final author = ChatAuthorValue.fromRendererJson(json);
      if (author == null) return null;
      return ChatMembershipValue(
        timestamp: (json["timestampUsec"] as String).toInt(),
        author: author,
        id: json["id"],
        timestampText: json["timestampText"]?["simpleText"],
        messageJson: json["message"],
        simplifiedMessage:
            ChatText.messageJsonToString(json["message"] ?? const {}),
        headerTextJson: json["headerPrimaryText"],
        headerSubtextJson: json["headerSubtext"],
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}

class ChatStickerValue extends AuthoredChatItemValue {
  const ChatStickerValue({
    required super.timestamp,
    required super.author,
    required super.id,
    required super.timestampText,
    required this.sticker,
    required this.moneyChipBackgroundColor,
    required this.moneyChipTextColor,
    required this.purchaseAmount,
    required this.stickerDisplayWidth,
    required this.stickerDisplayHeight,
    required this.backgroundColor,
  });

  final ChatRasterImageValue sticker;
  final int moneyChipBackgroundColor;
  final int moneyChipTextColor;
  final String purchaseAmount;
  final int stickerDisplayWidth;
  final int stickerDisplayHeight;
  final int backgroundColor;

  @override
  List<Object?> get props => [
        timestamp,
        author,
        id,
        timestampText,
        sticker,
        moneyChipBackgroundColor,
        moneyChipTextColor,
        purchaseAmount,
        stickerDisplayWidth,
        stickerDisplayHeight,
        backgroundColor,
      ];

  static ChatStickerValue? fromRendererJson(Map<String, dynamic> json) {
    try {
      final author = ChatAuthorValue.fromRendererJson(json);
      final sticker = ChatRasterImageValue.fromJson(json["sticker"]);
      if (author == null || sticker == null) return null;

      return ChatStickerValue(
        timestamp: (json["timestampUsec"] as String).toInt(),
        id: json["id"],
        timestampText: json["timestampText"]?["simpleText"],
        author: author,
        sticker: sticker,
        moneyChipBackgroundColor: json["moneyChipBackgroundColor"],
        moneyChipTextColor: json["moneyChipTextColor"],
        purchaseAmount: json["purchaseAmountText"]?["simpleText"],
        stickerDisplayWidth: json["stickerDisplayWidth"],
        stickerDisplayHeight: json["stickerDisplayHeight"],
        backgroundColor: json["backgroundColor"],
      );
    } on TypeError catch (_) {
      // json not formatted correctly
      return null;
    }
  }
}

// https://support.google.com/youtube/answer/2524549
// TODO gifted memberships
// TODO polls (does not show up in replays - see https://support.google.com/youtube/answer/2524549?hl=en#zippy=%2Ccreate-a-live-poll)
// TODO pinned
// TODO product items?
// TODO live reactions? (might be impossible)
// TODO deleted messages

// all possible items? 
// (from https://github.com/LuanRT/YouTube.js/tree/main/src/parser/classes/livechat/items)
// - LiveChatAutoModMessage
// - LiveChatBanner
// - LiveChatBannerHeader
// - LiveChatBannerPoll 
// - LiveChatMembershipItem
// - LiveChatPaidMessage
// - LiveChatPaidSticker
// - LiveChatPlaceholderItem
// - LiveChatProductItem
// - LiveChatRestrictedParticipation
// - LiveChatTextMessage
// - LiveChatTickerPaidMessageItem
// - LiveChatTickerPaidStickerItem
// - LiveChatTickerSponsorItem
// - LiveChatViewerEngagementMessage
// - PollHeader