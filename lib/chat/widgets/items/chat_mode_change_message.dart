import 'package:flutter/material.dart';

import '../../data/chat_item_values.dart';
import '../../youtube_theme.dart';
import '../chat_text.dart';

class ChatModeChangeMessage extends StatelessWidget {
  const ChatModeChangeMessage({super.key, required this.value});

  final ChatModeChangeMessageValue value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: YoutubeTheme.cardBackground.withOpacity(0.6),
      shape: YoutubeTheme.cardShape,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: Column(
          children: [
          // TODO allow other icons?
          const Icon(
            Icons.slow_motion_video,
            size: 40,
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: ChatText.jsonToSpans(
                json: value.textJson,
                normalStyle: YoutubeTheme.messageStyle,
              ),
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: ChatText.jsonToSpans(
                json: value.subtextJson,
                normalStyle: YoutubeTheme.messageStyle,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
