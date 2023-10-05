import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:shimmer/shimmer.dart';

import '../data/chat_image_value.dart';
import '../data/chat_item_values.dart';
import '../data/chat_ticker_value.dart';
import '../youtube_theme.dart';
import 'chat_author.dart';
import 'chat_author_avatar.dart';
import 'chat_text.dart';
import 'items/chat_item.dart';

class ChatTicker extends StatelessWidget {
  const ChatTicker({
    super.key,
    required this.value,
    required this.completionPercentage,
  });

  final ChatTickerValue value;
  final double completionPercentage;

  @override
  Widget build(BuildContext context) {
    final item = ChatItemValue.fromJson(value.itemJson);

    final messageSpans = ChatText.jsonToSpans(
      json: value.detailTextJson ?? const {},
      normalStyle: const TextStyle(overflow: TextOverflow.ellipsis),
    );
    final message = messageSpans.isNotEmpty
        ? RichText(text: TextSpan(children: messageSpans))
        : null;

    final thumbnails = value.thumbnails.mapNotNull(_buildThumbnail);

    final name = ChatAuthor(
      author: value.author,
      normalStyle: const TextStyle(overflow: TextOverflow.ellipsis),
    );

    return SizedBox(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          side: BorderSide.none,
          maximumSize: const Size(140, 10),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: YoutubeTheme.cardShape,
                contentPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                content: ChatItem(value: item),
              );
            },
          );
        },
        child: Ink(
          height: 32,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1 - completionPercentage, 0],
              colors: [
                Color(value.startBackgroundColor),
                Color(value.endBackgroundColor),
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatAuthorAvatar(
                  author: value.author,
                  size: const Size.square(24),
                  tooltipDirection: AxisDirection.down,
                ),
                if (thumbnails.isEmpty)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: message ?? name,
                    ),
                  ),
                if (thumbnails.isNotEmpty) const SizedBox(width: 4),
                if (thumbnails.isNotEmpty) ...thumbnails,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildThumbnail(ChatImageValue thumbnail) {
    return JustTheTooltip(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              height: 48,
              width: 48,
              imageUrl: thumbnail.biggestUrl,
              fadeInDuration: const Duration(milliseconds: 40),
              errorWidget: (_, __, ___) => const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.error),
              ),
              progressIndicatorBuilder: (_, __, ___) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                period: const Duration(milliseconds: 500),
                enabled: true,
                child: Container(width: 48, height: 48, color: Colors.white),
              ),
            ),
            if (thumbnail.label != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(thumbnail.label!),
              ),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          height: 24,
          width: 24,
          imageUrl: thumbnail.smallestUrl,
          fadeInDuration: const Duration(milliseconds: 40),
          errorWidget: (_, __, ___) => const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
