import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../../data/chat_item_values.dart';
import '../../youtube_theme.dart';
import '../chat_text.dart';

class ChatViewerEngagementMessage extends StatelessWidget {
  const ChatViewerEngagementMessage({super.key, required this.value});

  final ChatViewerEngagementMessageValue value;

  @override
  Widget build(BuildContext context) {
    final icon = switch (value.iconType) {
      "YOUTUBE_ROUND" => const Icon(
          Icons.play_circle_filled,
          color: Colors.red,
          size: 24,
        ),
      // TODO "CELEBRATION"
      _ => JustTheTooltip(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value.iconType),
          ),
          child: const Icon(
            Icons.question_mark,
            color: Colors.grey,
          ),
        ),
    };

    return Card(
      color: YoutubeTheme.cardBackground,
      shape: YoutubeTheme.cardShape,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: icon,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: ChatText.jsonToSpans(
                      json: value.messageJson,
                      normalStyle: YoutubeTheme.viewerEngagementStyle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
