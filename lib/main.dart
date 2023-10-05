import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import 'chat/chat_controller.dart';
import 'chat/data/chat_data.dart';
import 'chat/widgets/chat_box.dart';
import 'chat/widgets/chat_load_progress.dart';
import 'file_required.dart';
import 'generic_player_controls.dart';
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
  List<ChewieController> chewies = [];
  ChatController? chatController;

  final loggerOutput = MemoryOutput(
    bufferSize: 200,
  );
  late final logger = Logger(
    output: loggerOutput,
  );

  ChatMetadata? _chatLoadMetadata;
  int _chatLoadedBytes = 0;
  int? _chatTotalBytes = 0;
  bool _chatLoading = false;

  ChatLoadMetadata? _chatLoadMetadata;

  @override
  void initState() {
    super.initState();
    initPlayer(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
  }

  @override
  void dispose() {
    clearPlayer();
    super.dispose();
  }

  Future<void> initPlayer(String url) async {
    final group = SyncedPlayerGroupController(
      children: [
        SyncedController(
          SimpleVideoController(
            videoPlayerController: VideoPlayerController.networkUrl(
              Uri.parse(url),
              videoPlayerOptions: VideoPlayerOptions(
                allowBackgroundPlayback: true,
                mixWithOthers: true,
              ),
            ),
          ),
          offset: const Duration(seconds: -10),
        ),
        SyncedController(
          SimpleVideoController(
            videoPlayerController: VideoPlayerController.networkUrl(
              Uri.parse(url),
              videoPlayerOptions: VideoPlayerOptions(
                allowBackgroundPlayback: true,
                mixWithOthers: true,
              ),
            ),
          ),
        ),
        SyncedController(
          SimpleVideoController(
            videoPlayerController: VideoPlayerController.networkUrl(
              Uri.parse(url),
              videoPlayerOptions: VideoPlayerOptions(
                allowBackgroundPlayback: true,
                mixWithOthers: true,
              ),
            ),
          ),
          offset: const Duration(seconds: 10),
        ),
      ],
      marginOfError: const Duration(seconds: 2),
    );

    await group.initialize();

    for (final child in group.children) {
      child.controller.addListener(() => setState(() {}));
    }

    group.addListener(() {
      setState(() {});
    });

    setState(() {
      this.group = group;
      chewies = group.children
          .map((e) => ChewieController(
                videoPlayerController: (e.controller as SimpleVideoController)
                    .videoPlayerController,
                progressIndicatorDelay: null,
              ))
          .toList();
    });
  }

  void clearPlayer() {
    group?.disposeAll();

    setState(() {
      group = null;
      chewies = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () => group?.play(),
                  icon: const Icon(Icons.play_arrow)),
              IconButton(
                  onPressed: () => group?.pause(),
                  icon: const Icon(Icons.pause)),
              IconButton(
                  onPressed: () => group?.sync(),
                  icon: const Icon(Icons.refresh)),
              IconButton(
                onPressed: () {
                  for (final event in loggerOutput.buffer) {
                    event.lines.forEach(debugPrint);
                  }
                },
                icon: const Icon(Icons.bug_report),
              ),
            ],
            bottom: const TabBar(tabs: [
              Tab(text: "Video"),
              Tab(text: "Chat"),
            ]),
          ),
          body: TabBarView(children: [
            _buildVideos(),
            _buildChat(),
          ])),
    );
  }

  Widget _buildChat() {
    final chatController = this.chatController;

    Widget? child;

    // loaded
    if (chatController != null) {
      child = ChatBox(controller: chatController);
    }

    // loading
    if (_chatLoading) {
      child = ChatLoadProgress(metadata: _chatLoadMetadata);
    }

    return FileRequired(
      icon: Icons.chat,
      text: "Pick chat replay file (.json)",
      onFileChosen: _loadChat,
      child: child,
    );
  }

  void _loadChat(XFile file) async {
    if (_chatLoading) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Already loading...")));
      }
      return;
    }

    final size = await file.length();
    setState(() {
      _chatLoading = true;
    });

    debugPrint("Load size: $size");

    await chatController?.dispose();

    chatController = await ChatController.parseFile(
      file,
      logger: logger,
      onProgress: (metadata) {
        setState(() {
          _chatLoadMetadata = metadata;
        });
      },
      inMemory: false,
    );

    if (chatController == null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Parsing failed.")));
      }
    }

    setState(() {
      _chatLoading = false;
      _chatLoadMetadata = null;
    });
  }

  Widget _buildVideos() {
    final group = this.group;
    return group == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              GenericPlayerControls(
                state: group.value,
                onPositionChanged: (newPosition) {
                  group.setPosition(newPosition);
                },
              ),
              ...chewies.zip(group.children,
                  (chewie, synced) => _buildVideo(chewie, synced))
            ],
          );
  }

  Widget _buildVideo(ChewieController chewie, SyncedController synced) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: chewie.videoPlayerController.value.aspectRatio,
          child:
              Container(color: Colors.black, child: Chewie(controller: chewie)),
        ),
        Text(synced.controller.value.toStringCompact(),
            style: const TextStyle(backgroundColor: Colors.white)),
      ],
    );
  }
}
