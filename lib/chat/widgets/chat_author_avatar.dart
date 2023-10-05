import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../data/chat_author_value.dart';
import 'chat_author_details.dart';

class ChatAuthorAvatar extends StatelessWidget {
  const ChatAuthorAvatar({
    super.key,
    required this.author,
    required this.size,
    required this.tooltipDirection,
  });

  final ChatAuthorValue author;
  final Size size;
  final AxisDirection tooltipDirection;

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      preferredDirection: tooltipDirection,
      triggerMode: TooltipTriggerMode.tap,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatAuthorDetails(author: author),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          height: size.height,
          width: size.width,
          imageUrl: author.photo.smallestUrl,
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
