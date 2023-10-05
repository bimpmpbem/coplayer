import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../data/chat_image_value.dart';

abstract class ChatText {
  static String messageJsonToString(Map<String, dynamic> textJson) =>
      textJson["simpleText"] ??
      (textJson.getOrElse('runs', () => const []) as List)
          .mapNotNull((run) => run["text"] as String?)
          .join();

  static List<InlineSpan> jsonToSpans({
    required Map<String, dynamic> json,
    TapGestureRecognizer? Function(String url, String text)?
        urlRecognizerBuilder,
    TextStyle? normalStyle,
    TextStyle? urlStyle,
    TextStyle? tooltipStyle,
    double smallImageSize = 24,
    double bigImageSize = 48,
  }) {
    final simple = json["simpleText"];
    if (simple is String) {
      return [TextSpan(text: simple)];
    }

    final runs = json["runs"];
    if (runs is List) {
      final spans = runs.mapIndexedNotNull<InlineSpan>((index, run) {
        if (run is! Map<String, dynamic>) return null;

        final text = run['text'];

        final url = run['navigationEndpoint']?['urlEndpoint']?['url'] ?? "";
        if (url is! String) return null;

        ChatImageValue? emoji;
        List<String> emojiShortcuts = [];
        try {
          emoji = ChatImageValue.fromJson(run["emoji"]?["image"]);
          final shortcuts = run["emoji"]?["shortcuts"] as List;
          emojiShortcuts.addAll(shortcuts.cast());
        } on TypeError catch (_) {
          // bad json/no images
        }

        // create/find tap recognizer
        TapGestureRecognizer? recognizer;
        if (url.isNotBlank) {
          recognizer = urlRecognizerBuilder?.invoke(url, text);
        }

        // url/text
        // TODO tooltip preview for URLs?
        if (text is String) {
          TextStyle style =
              (url.isBlank ? normalStyle : urlStyle) ?? const TextStyle();

          if (run.getOrElse('bold', () => false) as bool) {
            style = style.copyWith(fontWeight: FontWeight.bold);
          }
          if (run.getOrElse('italics', () => false) as bool) {
            style = style.copyWith(fontStyle: FontStyle.italic);
          }
          if (run.getOrElse('strikethrough', () => false) as bool) {
            style = style.copyWith(decoration: TextDecoration.lineThrough);
          }

          return TextSpan(
            text: text,
            recognizer: recognizer,
            style: style,
          );
        }

        // emoji
        if (emoji != null) {
          final smallImage = switch (emoji) {
            ChatVectorImageValue value => SvgPicture.network(
                value.url,
                height: smallImageSize,
                width: smallImageSize,
              ),
            ChatRasterImageValue value => CachedNetworkImage(
                imageUrl: value.smallestUrl,
                height: smallImageSize,
                width: smallImageSize,
                fadeInDuration: const Duration(milliseconds: 40),
                errorWidget: (_, __, ___) => const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.error),
                ),
              ),
            _ => null,
          };
          final bigImage = switch (emoji) {
            ChatVectorImageValue value => SvgPicture.network(
                value.url,
                height: bigImageSize,
                width: bigImageSize,
              ),
            ChatRasterImageValue value => CachedNetworkImage(
                imageUrl: value.biggestUrl,
                height: bigImageSize,
                width: bigImageSize,
                fadeInDuration: const Duration(milliseconds: 40),
                errorWidget: (_, __, ___) => const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.error),
                ),
              ),
            _ => null,
          };

          return WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: JustTheTooltip(
              preferredDirection: AxisDirection.up,
              triggerMode: TooltipTriggerMode.tap,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    bigImage!,
                    ...emojiShortcuts.map((e) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(e, style: tooltipStyle),
                        )),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: smallImage,
              ),
            ),
          );
        }

        return null;
      }).toList();

      return spans.toList();
    }

    return [];
  }
}
