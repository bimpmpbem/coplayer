import 'package:flutter/material.dart';

import '../../data/chat_item_values.dart';
import '../../youtube_theme.dart';
import '../chat_author.dart';
import '../chat_author_avatar.dart';
import '../chat_text.dart';

final testMem = {};

class ChatTextMessage extends StatelessWidget {
  const ChatTextMessage({super.key, required this.value});

  final ChatTextMessageValue value;

  @override
  Widget build(BuildContext context) {

    return Row(
      // textBaseline: TextBaseline.alphabetic,
      // crossAxisAlignment: CrossAxisAlignment.baseline,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatAuthorAvatar(
          author: value.author,
          size: const Size.square(24),
          tooltipDirection: AxisDirection.right,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Baseline(
            baseline: 15,
            baselineType: TextBaseline.alphabetic,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <InlineSpan>[
                  TextSpan(
                    text: value.timestampText,
                    style: YoutubeTheme.timestampStyle,
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  WidgetSpan(
                    baseline: TextBaseline.alphabetic,
                    alignment: PlaceholderAlignment.baseline,
                    child: DefaultTextStyle(
                      style: YoutubeTheme.messageAuthorStyle,
                      child: ChatAuthor(author: value.author),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 8)),
                  if (value.messageJson != null)
                    ...ChatText.jsonToSpans(
                      json: value.messageJson!,
                      smallImageSize: 24,
                      normalStyle: YoutubeTheme.messageStyle,
                      urlStyle: YoutubeTheme.chatUrlStyle,
                      tooltipStyle:
                          const TextStyle(fontWeight: FontWeight.w600),
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
