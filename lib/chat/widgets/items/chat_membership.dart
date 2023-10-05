import 'package:flutter/material.dart';

import '../../data/chat_item_values.dart';
import '../../youtube_theme.dart';
import '../chat_author.dart';
import '../chat_author_avatar.dart';
import '../chat_text.dart';

class ChatMembership extends StatelessWidget {
  const ChatMembership({super.key, required this.value});

  final ChatMembershipValue value;

  @override
  Widget build(BuildContext context) {
    TextStyle authorStyle = YoutubeTheme.membershipAuthorBigStyle;
    TextStyle subtextStyle = YoutubeTheme.membershipSubtextBigStyle;
    if (value.headerTextJson != null) {
      authorStyle = YoutubeTheme.membershipAuthorSmallStyle;
      subtextStyle = YoutubeTheme.membershipSubtextSmallStyle;
    }

    final author = ChatAuthor(
      author: value.author,
      normalStyle: authorStyle,
      moderatorStyle: authorStyle,
      ownerStyle: authorStyle,
    );

    final headerSpans = (value.headerTextJson != null)
        ? ChatText.jsonToSpans(
            json: value.headerTextJson!,
            normalStyle: YoutubeTheme.membershipHeaderStyle,
          )
        : null;

    final subtextSpans = ChatText.jsonToSpans(
      json: value.headerSubtextJson,
      normalStyle: subtextStyle,
    );

    final messageSpans = (value.messageJson != null)
        ? ChatText.jsonToSpans(
            json: value.messageJson!,
            normalStyle: YoutubeTheme.membershipMessageStyle,
          )
        : null;

    return Card(
      margin: EdgeInsets.zero,
      shape: YoutubeTheme.cardShape,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: YoutubeTheme.membershipHeaderBackground,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          author,
                          if (headerSpans != null)
                            RichText(text: TextSpan(children: headerSpans)),
                          RichText(
                            text: TextSpan(
                              children: subtextSpans,
                              style: subtextStyle,
                            ),
                            textAlign: TextAlign.start,
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
              color: YoutubeTheme.membershipBodyBackground,
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
