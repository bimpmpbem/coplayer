import 'package:flutter/foundation.dart';
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
  ChewieController? chewieController;

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
    final videoPlayerController = VideoPlayerController.network(url,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
      ..addListener(videoListener);
    await videoPlayerController.initialize();

    setState(() {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
      );
    });
  }

  void clearPlayer() {
    chewieController?.videoPlayerController.removeListener(videoListener);
    chewieController?.videoPlayerController.dispose();
    chewieController?.dispose();

    setState(() {
      chewieController = null;
    });
  }

  void videoListener() {
    if (kDebugMode) {
      print("video state: ${chewieController?.videoPlayerController.value}");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = this.chewieController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: chewieController == null
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  AspectRatio(
                    aspectRatio: chewieController
                        .videoPlayerController.value.aspectRatio,
                    child: Container(
                        color: Colors.black,
                        child: Chewie(controller: chewieController)),
                  ),
                  Slider(
                    max: chewieController
                        .videoPlayerController.value.duration.inMicroseconds
                        .toDouble(),
                    value: chewieController
                        .videoPlayerController.value.position.inMicroseconds
                        .toDouble(),
                    onChanged: (value) {
                      chewieController.videoPlayerController
                          .seekTo(Duration(microseconds: value.toInt()));
                    },
                  )
                ],
              ),
      ),
    );
  }
}
