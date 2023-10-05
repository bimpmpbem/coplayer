import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../data/chat_author_value.dart';
import '../youtube_theme.dart';

class ChatAuthorDetails extends StatefulWidget {
  const ChatAuthorDetails({
    super.key,
    required this.author,
  });

  final ChatAuthorValue author;

  @override
  State<ChatAuthorDetails> createState() => _ChatAuthorDetailsState();
}

class _ChatAuthorDetailsState extends State<ChatAuthorDetails> {
  @override
  Widget build(BuildContext context) {
    // TODO show badges
    // TODO show channel info? (sub count, handle, account age, etc)
    // TODO show stats? (message count, frequency, money donated, etc)

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          height: widget.author.photo.bigSize.height,
          width: widget.author.photo.bigSize.width,
          imageUrl: widget.author.photo.biggestUrl,
          fadeInDuration: const Duration(milliseconds: 80),
          fadeOutDuration: const Duration(milliseconds: 80),
          errorWidget: (_, __, ___) => Container(
            color: Colors.red,
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.error),
                Text(
                  "Can't load",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          progressIndicatorBuilder: (_, __, ___) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            period: const Duration(milliseconds: 500),
            enabled: true,
            child: Container(width: 64, height: 64, color: Colors.white),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.author.name,
              style: YoutubeTheme.messageAuthorStyle,
            ),
          ),
        ),
      ],
    );
  }
}
