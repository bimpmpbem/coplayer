import 'package:flutter/material.dart';

import '../../data/chat_item_values.dart';
import 'chat_membership.dart';
import 'chat_mode_change_message.dart';
import 'chat_paid_text_message.dart';
import 'chat_sticker.dart';
import 'chat_text_message.dart';
import 'chat_viewer_engagement_message.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.value,
  });

  final ChatItemValue? value;

  @override
  Widget build(BuildContext context) {
    return switch (value) {
      ChatModeChangeMessageValue value => ChatModeChangeMessage(value: value),
      ChatMembershipValue value => ChatMembership(value: value),
      ChatPaidMessageValue value => ChatPaidMessage(value: value),
      ChatTextMessageValue value => ChatTextMessage(value: value),
      ChatStickerValue value => ChatSticker(value: value),
      ChatViewerEngagementMessageValue value =>
        ChatViewerEngagementMessage(value: value),
      _ => const Text("Unknown item"),
    };
  }
}
