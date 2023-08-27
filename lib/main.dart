import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'synced_player_group_controller.dart';
import 'video/simple_video_controller.dart';

void main() {
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
    final group = SyncedPlayerGroupController(children: [
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
    ]);

    await group.initialize();

    setState(() {
      this.group = group;
      chewies = group.children
          .map((e) => ChewieController(
              videoPlayerController: (e.controller as SimpleVideoController)
                  .videoPlayerController))
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
    final group = this.group; // null safety

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
        ],
      ),
      body: Center(
          child: group == null
              ? const CircularProgressIndicator()
              : ListView(
                  children: chewies.map((e) => _buildVideo(e)).toList())),
    );
  }

  Widget _buildVideo(ChewieController? controller) => controller != null
      ? AspectRatio(
          aspectRatio: controller.videoPlayerController.value.aspectRatio,
          child: Container(
              color: Colors.black, child: Chewie(controller: controller)),
        )
      : const Center(child: CircularProgressIndicator());
}
