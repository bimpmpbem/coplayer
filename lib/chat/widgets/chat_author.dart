import 'package:cached_network_image/cached_network_image.dart';
import 'package:coplayer/chat/data/chat_image_value.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../data/chat_author_value.dart';
import '../youtube_theme.dart';

class ChatAuthor extends StatelessWidget {
  const ChatAuthor({
    super.key,
    required this.author,
    this.normalStyle,
    this.moderatorStyle,
    this.ownerStyle,
  });

  final ChatAuthorValue author;
  final TextStyle? normalStyle;
  final TextStyle? moderatorStyle;
  final TextStyle? ownerStyle;

  static const smallImageSize = 16.0;
  static const bigImageSize = 36.0;

  @override
  Widget build(BuildContext context) {
    bool isOwner = false;
    bool isModerator = false;

    final badges = [];

    for (final badgeJson in author.badgesJsons) {
      if (badgeJson is! Map<String, dynamic>) continue;

      final iconType = badgeJson["liveChatAuthorBadgeRenderer"]?["icon"]
          ?["iconType"] as String?;

      final imageLabel =
          badgeJson["liveChatAuthorBadgeRenderer"]?["tooltip"] as String?;

      switch (iconType) {
        case "OWNER":
          isOwner = true;
          break; // no badge, but different name style
        case "VERIFIED":
          badges.add(
            _buildBadge(
              smallBadge: const Icon(
                Icons.check,
                size: smallImageSize,
                color: Color.fromARGB(255, 153, 153, 153),
              ),
              bigBadge: const Icon(
                Icons.check,
                size: bigImageSize,
                color: Color.fromARGB(255, 153, 153, 153),
              ),
              label: imageLabel,
            ),
          );
          break;
        case "MODERATOR":
          isModerator = true;
          badges.add(
            _buildBadge(
              smallBadge: const Icon(
                Icons.key,
                size: smallImageSize,
                color: YoutubeTheme.authorIsModeratorColor,
              ),
              bigBadge: const Icon(
                Icons.key,
                size: bigImageSize,
                color: YoutubeTheme.authorIsModeratorColor,
              ),
              label: imageLabel,
            ),
          );
          break;
        default: // custom badge
          final imageJson =
              badgeJson["liveChatAuthorBadgeRenderer"]?["customThumbnail"];
          if (imageJson is! Map<String, dynamic>) break;

          final image = ChatImageValue.fromJson(imageJson);

          badges.add(
            _buildBadge(
              smallBadge: CachedNetworkImage(
                imageUrl: image?.smallestUrl ?? "NO URL",
                width: smallImageSize,
                height: smallImageSize,
                fadeInDuration: const Duration(milliseconds: 40),
                errorWidget: (_, __, ___) => const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.error),
                ),
              ),
              bigBadge: CachedNetworkImage(
                height: bigImageSize,
                width: bigImageSize,
                imageUrl: image?.biggestUrl ?? "NO URL",
                fadeInDuration: const Duration(milliseconds: 40),
                errorWidget: (_, __, ___) => const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.error),
                ),
              ),
              label: imageLabel,
            ),
          );
          break;
        // TODO verified artist
      }
    }

    final forcedColor =
        (author.nameTextColor != null) ? Color(author.nameTextColor!) : null;

    Widget nameWidget = Text(
      author.name,
      style: normalStyle?.copyWith(color: forcedColor),
    );
    if (isOwner) {
      nameWidget = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: YoutubeTheme.messageAuthorIsOwnerBackground),
        child: Text(
          author.name,
          style: ownerStyle?.copyWith(color: forcedColor),
        ),
      );
    } else if (isModerator) {
      nameWidget = Text(
        author.name,
        style: moderatorStyle?.copyWith(color: forcedColor),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(child: nameWidget),
        ...badges,
      ],
    );
  }

  Widget _buildBadge({
    required Widget smallBadge,
    required Widget bigBadge,
    required String? label,
  }) {
    return JustTheTooltip(
      preferredDirection: AxisDirection.up,
      triggerMode: TooltipTriggerMode.tap,
      content: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bigBadge,
            if (label != null)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: smallBadge,
      ),
    );
  }
}
