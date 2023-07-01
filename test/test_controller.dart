import 'package:coplayer/duration_range.dart';
import 'package:coplayer/synced_player.dart';

class TestController extends GenericPlayerController {
  TestController({
    GenericPlayerValue initialValue =
        const GenericPlayerValue(positionRange: DurationRange.zero),
  }) : super() {
    value = initialValue;
  }

  @override
  Future<void> initialize() async =>
      value = value.copyWith(isInitialized: true);

  @override
  Future<void> pause() async => value = value.copyWith(isPlaying: false);

  @override
  Future<void> play() async => value = value.copyWith(isPlaying: true);

  @override
  Future<Duration?> get position async => value.position;

  @override
  Future<void> setPlaybackSpeed(double speed) async =>
      value = value.copyWith(playbackSpeed: speed);

  @override
  Future<void> setPosition(Duration position) async =>
      value = value.copyWith(position: position);
}
