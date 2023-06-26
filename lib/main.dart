import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
  ChewieController? chewieController1;
  ChewieController? chewieController2;

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
    final controller1 = VideoPlayerController.network(url,
        videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true, mixWithOthers: true));
    final controller2 = VideoPlayerController.network(url,
        videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true, mixWithOthers: true));

    await controller1.initialize();
    await controller2.initialize();

    setState(() {
      chewieController1 = ChewieController(
        videoPlayerController: controller1,
      );
      chewieController2 = ChewieController(
        videoPlayerController: controller2,
      );
    });
  }

  void clearPlayer() {
    chewieController1?.videoPlayerController.dispose();
    chewieController1?.dispose();
    chewieController2?.videoPlayerController.dispose();
    chewieController2?.dispose();

    setState(() {
      chewieController1 = null;
      chewieController2 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chewieController1 = this.chewieController1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: chewieController1 == null
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(child: _buildVideo(chewieController1)),
                  Expanded(child: _buildVideo(chewieController2)),
                ],
              ),
      ),
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
