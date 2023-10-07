import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import 'chat/chat_controller.dart';
import 'layout/simple_layout.dart';
import 'synced_player_group_controller.dart';
import 'video/simple_video_controller.dart';

void main() {
  registerWith();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coplayer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Coplayer'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SyncedPlayerGroupController? group;
  ChatController? chatController;
  SimpleVideoController? videoController;

  final loggerOutput = MemoryOutput(
    bufferSize: 200,
  );
  late final logger = Logger(
    output: loggerOutput,
  );

  void recreateGroup() async {
    group = SyncedPlayerGroupController(children: [
      if (videoController != null) SyncedController(videoController!),
      if (chatController != null) SyncedController(chatController!),
    ]);
    await group?.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => group?.play(),
              icon: const Icon(Icons.play_arrow)),
          IconButton(
              onPressed: () => group?.pause(), icon: const Icon(Icons.pause)),
          IconButton(
              onPressed: () => group?.sync(), icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () {
              for (final event in loggerOutput.buffer) {
                event.lines.forEach(debugPrint);
              }
            },
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
      body: SimpleLayout(
        showDebugInfo: true,
        targetChatWidth: 350,
        videoController: videoController,
        chatController: chatController,
        onVideoFileChosen: (file) async {
          videoController?.dispose();
          final newController = SimpleVideoController(
              videoPlayerController: (kIsWeb)
                  ? VideoPlayerController.networkUrl(Uri.parse(file.path))
                  : VideoPlayerController.file(File(file.path)));
          await newController.initialize();
          setState(() {
            videoController = newController;
          });
          recreateGroup();
        },
        onChatFileChosen: (file) {
          chatController?.dispose();
          setState(() {
            chatController = ChatController(source: file);
          });
          recreateGroup();
        },
      ),
    );
  }
}
