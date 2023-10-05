import 'package:flutter/material.dart';

import '../../data/chat_item_values.dart';
import '../../youtube_theme.dart';
import '../chat_author.dart';
import '../chat_author_avatar.dart';
import '../chat_text.dart';

class ChatPaidMessage extends StatelessWidget {
  const ChatPaidMessage({super.key, required this.value});

  final ChatPaidMessageValue value;

  @override
  Widget build(BuildContext context) {
    final messageSpans = (value.messageJson != null)
        ? ChatText.jsonToSpans(
            json: value.messageJson!,
            normalStyle: YoutubeTheme.paidMessageStyle,
          )
        : null;

    return Card(
      margin: EdgeInsets.zero,
      shape: YoutubeTheme.cardShape,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Color(value.headerBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                // height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ChatAuthorAvatar(
                      author: value.author,
                      size: const Size.square(40),
                      tooltipDirection: AxisDirection.up,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ChatAuthor(
                            author: value.author,
                            normalStyle: YoutubeTheme.paidMessageAuthorStyle,
                            moderatorStyle: YoutubeTheme.paidMessageAuthorStyle,
                            ownerStyle: YoutubeTheme.paidMessageAuthorStyle,
                          ),
                          Text(
                            textAlign: TextAlign.start,
                            value.purchaseAmount,
                            maxLines: 1,
                            style: YoutubeTheme.purchaseAmountStyle,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (messageSpans != null)
            Container(
              color: Color(value.bodyBackgroundColor),
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RichText(
                  text: TextSpan(children: messageSpans),
                ),
              ),
            )
        ],
      ),
    );
  }
}
