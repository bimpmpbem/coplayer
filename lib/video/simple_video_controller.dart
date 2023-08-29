import 'package:video_player/video_player.dart';
import 'package:mutex/mutex.dart';

import '../duration_range.dart';
import '../generic_player_controller.dart';
import '../generic_player_state.dart';

/// Wrapper for [VideoPlayerController]
// TODO rename to GenericVideoPlayerController?
class SimpleVideoController extends GenericPlayerController {
  SimpleVideoController({
    super.obstructionBehavior = ObstructionBehavior.none,
    required this.videoPlayerController,
  });

  final VideoPlayerController videoPlayerController;

  final _mutex = Mutex();

  @override
  Future<void> initialize() async {
    await videoPlayerController.initialize();

    final controllerValue = videoPlayerController.value;

    value = GenericPlayerState.now(
      positionRange: Duration.zero.rangeTo(controllerValue.duration),
      position: controllerValue.position,
      playState: decipherPlayState(controllerValue),
      errorDescription: controllerValue.errorDescription,
      isLooping: controllerValue.isLooping,
      playbackSpeed: controllerValue.playbackSpeed,
    );

    videoPlayerController.addListener(_updateState);
  }

  @override
  Future<void> dispose() async {
    videoPlayerController.removeListener(_updateState);
    await videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Future<void> setPosition(Duration position) =>
      videoPlayerController.seekTo(position);

  @override
  Future<void> pause() => videoPlayerController.pause();

  @override
  Future<void> play() => videoPlayerController.play();

  @override
  // TODO check latency
  Future<Duration?> get position => videoPlayerController.position;

  @override
  Future<void> setPlaybackSpeed(double speed) =>
      videoPlayerController.setPlaybackSpeed(speed);

  Future<void> _updateState() async {
    await _mutex.protect(() async {
      GenericPlayerState nextState = value;
      final controllerValue = videoPlayerController.value;

      if (value.positionRange.value.endInclusive != controllerValue.duration) {
        nextState = nextState.copyWith(
            positionRange: Duration.zero.rangeTo(controllerValue.duration));
      }

      // can't use controllerValue.position cause it's not always up to date
      // (for example, calling pause() does not update position)
      // TODO fix video_player?
      if (value.position.value != await videoPlayerController.position) {
        nextState = nextState.copyWith(position: controllerValue.position);
      }

      final playState = decipherPlayState(controllerValue);
      if (value.playState.value != playState) {
        nextState = nextState.copyWith(playState: playState);
      }

      if (value.errorDescription?.value != controllerValue.errorDescription) {
        nextState = nextState.copyWith(
            errorDescription: controllerValue.errorDescription);
      }

      if (value.isLooping.value != controllerValue.isLooping) {
        nextState = nextState.copyWith(isLooping: controllerValue.isLooping);
      }

      if (value.playbackSpeed.value != controllerValue.playbackSpeed) {
        nextState =
            nextState.copyWith(playbackSpeed: controllerValue.playbackSpeed);
      }

      if (value != nextState) {
        value = nextState;
      }
    });
  }

  PlayState decipherPlayState(VideoPlayerValue controllerValue) {
    if (controllerValue.hasError) return PlayState.error;
    if (!controllerValue.isInitialized) return PlayState.uninitialized;
    if (!controllerValue.isPlaying) return PlayState.paused;
    if (controllerValue.isBuffering) return PlayState.playingBuffering;
    return PlayState.playing;
  }
}
