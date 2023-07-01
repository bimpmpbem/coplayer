import 'package:video_player/video_player.dart';

import '../duration_range.dart';
import '../synced_player.dart';

extension on VideoPlayerValue {
  GenericPlayerValue toGenericPlayerValue() => GenericPlayerValue(
    positionRange: Duration.zero.rangeTo(duration),
        position: position,
        isInitialized: isInitialized,
        isPlaying: isPlaying,
        isLooping: isLooping,
        isBuffering: isBuffering,
        playbackSpeed: playbackSpeed,
        errorDescription: errorDescription,
      );
}

/// Wrapper for [VideoPlayerController]
// TODO rename to GenericVideoPlayerController?
class SimpleVideoController extends GenericPlayerController {
  SimpleVideoController({
    super.obstructionBehavior = ObstructionBehavior.none,
    required this.controller,
  });

  final VideoPlayerController controller;

  @override
  Future<void> initialize() async {
    await controller.initialize();
    controller.addListener(_listener);

    value = controller.value.toGenericPlayerValue();
  }

  @override
  Future<void> dispose() async {
    controller.removeListener(_listener);
    await controller.dispose();
    super.dispose();
  }

  @override
  Future<void> setPosition(Duration position) => controller.seekTo(position);

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void> play() {
    return controller.play();
  }

  @override
  // TODO check latency
  Future<Duration?> get position => controller.position;

  @override
  Future<void> setPlaybackSpeed(double speed) =>
      controller.setPlaybackSpeed(speed);

  Future<void> _listener() async {
    // position update manually cause it isn't always up to date
    // (for example, calling pause() does not update position)
    // TODO fix video_player?
    value = controller.value
        .copyWith(position: await controller.position)
        .toGenericPlayerValue();
  }
}
