import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/chat_item_values.dart';
import '../../youtube_theme.dart';
import '../chat_author.dart';
import '../chat_author_avatar.dart';

class ChatSticker extends StatelessWidget {
  const ChatSticker({super.key, required this.value});

  final ChatStickerValue value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: YoutubeTheme.cardShape,
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Color(value.backgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            // height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                JustTheTooltip(
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: CachedNetworkImage(
                            imageUrl: value.sticker.biggestUrl,
                            height: value.sticker.bigSize.height,
                            width: value.sticker.bigSize.width,
                            fadeInDuration: const Duration(milliseconds: 80),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.red,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error),
                                  Text("Can't load"),
                                ],
                              ),
                            ),
                            progressIndicatorBuilder: (_, __, ___) =>
                                Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              period: const Duration(milliseconds: 500),
                              enabled: true,
                              child: Container(
                                  width: 64, height: 64, color: Colors.white),
                            ),
                          ),
                        ),
                        if (value.sticker.label != null)
                          Text(
                            value.sticker.label!,
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: value.sticker.smallestUrl,
                    height: value.sticker.smallSize.height,
                    width: value.sticker.smallSize.width,
                    fadeInDuration: const Duration(milliseconds: 80),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.red,
                      child: const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
