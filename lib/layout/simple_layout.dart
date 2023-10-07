import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

import '../chat/chat_controller.dart';
import '../chat/widgets/chat_box.dart';
import '../file_required.dart';
import '../video/simple_video_controller.dart';

class SimpleLayout extends StatefulWidget {
  const SimpleLayout({
    super.key,
    required this.videoController,
    required this.chatController,
    required this.onVideoFileChosen,
    required this.onChatFileChosen,
    required this.targetChatWidth,
    this.showDebugInfo = false,
  });

  final SimpleVideoController? videoController;
  final ChatController? chatController;
  final void Function(XFile file) onVideoFileChosen;
  final void Function(XFile file) onChatFileChosen;
  final double targetChatWidth;
  final bool showDebugInfo;

  @override
  State<SimpleLayout> createState() => _SimpleLayoutState();
}

class _SimpleLayoutState extends State<SimpleLayout> {
  ChewieController? chewie;

  @override
  void initState() {
    super.initState();
    chewie = (widget.videoController != null)
        ? ChewieController(
            videoPlayerController:
                widget.videoController!.videoPlayerController,
          )
        : null;
    if (widget.showDebugInfo) {
      widget.videoController?.addListener(refreshDebugInfo);
    }
  }

  @override
  void didUpdateWidget(SimpleLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoController != widget.videoController) {
      chewie = (widget.videoController != null)
          ? ChewieController(
              videoPlayerController:
                  widget.videoController!.videoPlayerController,
            )
          : null;

      if (widget.showDebugInfo) {
        oldWidget.videoController?.removeListener(refreshDebugInfo);
        widget.videoController?.addListener(refreshDebugInfo);
      }
    }
  }

  @override
  void dispose() {
    if (widget.showDebugInfo) {
      widget.videoController?.removeListener(refreshDebugInfo);
    }
    super.dispose();
  }

  refreshDebugInfo() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget video = FileRequired(
      icon: Icons.play_arrow,
      text: "Pick video file",
      onFileChosen: widget.onVideoFileChosen,
      child: (chewie != null)
          ? AspectRatio(
              aspectRatio: chewie!.videoPlayerController.value.aspectRatio,
              child: Container(
                  color: Colors.black, child: Chewie(controller: chewie!)),
            )
          : null,
    );
    if (widget.showDebugInfo) {
      video = Stack(
        children: [
          video,
          Text(widget.videoController?.value.toStringCompact() ?? "",
              style: const TextStyle(backgroundColor: Colors.white)),
        ],
      );
    }

    final chat = FileRequired(
      icon: Icons.chat,
      text: "Pick chat replay file (.json)",
      onFileChosen: widget.onChatFileChosen,
      child: (widget.chatController != null)
          ? ChatBox(controller: widget.chatController!)
          : null,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight > constraints.maxWidth ||
              constraints.maxWidth < widget.targetChatWidth) {
            return Column(
              children: [
                video,
                Expanded(child: chat),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(child: video),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: min(
                      widget.targetChatWidth,
                      constraints.maxWidth / 2,
                    ),
                  ),
                  child: chat,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
