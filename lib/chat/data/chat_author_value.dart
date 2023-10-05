import 'package:equatable/equatable.dart';

import 'chat_image_value.dart';

class ChatAuthorValue extends Equatable {
  const ChatAuthorValue({
    required this.name,
    required this.photo,
    required this.channelId,
    required this.badgesJsons,
    this.nameTextColor,
  });

  final String name;
  final ChatRasterImageValue photo;
  final String channelId;
  final List<dynamic> badgesJsons;
  final int? nameTextColor;

  @override
  List<Object?> get props => [
        name,
        photo,
        channelId,
        badgesJsons,
        nameTextColor,
      ];

  static ChatAuthorValue? fromRendererJson(Map<String, dynamic> json) {
    try {
      final photo = ChatRasterImageValue.fromJson(json["authorPhoto"]);
      if (photo == null) return null;

      return ChatAuthorValue(
        name: json["authorName"]?["simpleText"],
        photo: photo,
        badgesJsons: json["authorBadges"] ?? [],
        channelId: json["authorExternalChannelId"],
        nameTextColor: json["authorNameTextColor"],
      );
    } on TypeError catch (_) {
      return null;
    }
  }
}
