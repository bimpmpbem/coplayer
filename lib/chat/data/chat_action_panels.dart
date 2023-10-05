class LiveChatActionPanel {
  LiveChatActionPanel({required this.videoOffset});

  final String videoOffset;
}

class LiveChatRestrictedParticipationActionPanel extends LiveChatActionPanel {
  LiveChatRestrictedParticipationActionPanel({
    required super.videoOffset,
    required this.messageJson,
    required this.buttonsJson,
    required this.iconType,
  });

  final String messageJson;
  final String buttonsJson;
  final String iconType;
}
