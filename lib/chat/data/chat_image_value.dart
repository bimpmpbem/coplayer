import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class ChatImageValue extends Equatable {
  abstract final String? label;

  abstract final String smallestUrl;
  abstract final String biggestUrl;

  // TODO bestUrlForSize(Size size)?

  static ChatImageValue? fromJson(Map<String, dynamic> json) {
    return ChatVectorImageValue.fromJson(json) ??
        ChatRasterImageValue.fromJson(json);
  }
}

class ChatRasterImageValue extends Equatable implements ChatImageValue {
  const ChatRasterImageValue({
    required this.smallestUrl,
    required this.biggestUrl,
    required this.smallSize,
    required this.bigSize,
    this.label,
  });

  @override
  final String smallestUrl;
  @override
  final String biggestUrl;
  final Size smallSize;
  final Size bigSize;
  @override
  final String? label;

  @override
  List<Object?> get props => [
        smallestUrl,
        biggestUrl,
        smallSize,
        bigSize,
        label,
      ];

  static ChatRasterImageValue? fromJson(Map<String, dynamic> json) {
    try {
      final thumbnails = json['thumbnails'] as List<dynamic>?;

      if (thumbnails == null || thumbnails.isEmpty) return null;

      final label =
          json["accessibility"]?["accessibilityData"]?["label"] as String?;

      var smallUrl = thumbnails.first?['url'] as String;
      var bigUrl = thumbnails.last?['url'] as String;

      // for some reason urls are sometimes broken
      if (smallUrl.startsWith('//') == true) {
        smallUrl = "https:$smallUrl";
      }
      if (bigUrl.startsWith('//') == true) {
        bigUrl = "https:$bigUrl";
      }

      return ChatRasterImageValue(
        smallestUrl: smallUrl,
        biggestUrl: bigUrl,
        smallSize: Size(
          (thumbnails.first?['width'] as int).toDouble(),
          (thumbnails.first?['height'] as int).toDouble(),
        ),
        bigSize: Size(
          (thumbnails.last?['width'] as int).toDouble(),
          (thumbnails.last?['height'] as int).toDouble(),
        ),
        label: label,
      );
    } on TypeError catch (_) {
      return null;
    }
  }
}

class ChatVectorImageValue extends Equatable implements ChatImageValue {
  const ChatVectorImageValue({
    required this.url,
    this.label,
  });

  final String url;
  @override
  final String? label;

  @override
  String get biggestUrl => url;

  @override
  String get smallestUrl => url;

  @override
  List<Object?> get props => [
        url,
        label,
      ];

  static ChatVectorImageValue? fromJson(Map<String, dynamic> json) {
    try {
      final thumbnails = json['thumbnails'] as List<dynamic>?;

      if (thumbnails == null || thumbnails.isEmpty) return null;

      var url = thumbnails.first?['url'] as String;

      if (!url.endsWith('.svg')) return null;

      final label =
          json["accessibility"]?["accessibilityData"]?["label"] as String?;

      // for some reason urls are sometimes broken
      if (url.startsWith('//') == true) {
        url = "https:$url";
      }

      return ChatVectorImageValue(
        url: url,
        label: label,
      );
    } on TypeError catch (_) {
      return null;
    }
  }
}
