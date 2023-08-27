import 'package:coplayer/duration_range.dart';
import 'package:coplayer/generic_player_state.dart';
import 'package:coplayer/synced_player.dart';

class TestController extends GenericPlayerController {
  TestController({GenericPlayerState? initialValue}) : super() {
    value = initialValue ??
        GenericPlayerState.now(positionRange: DurationRange.zero);
  }

  @override
  Future<void> initialize() async =>
      value = value.copyWith(playState: PlayState.paused);

  @override
  Future<void> pause() async =>
      value = value.copyWith(playState: PlayState.paused);

  @override
  Future<void> play() async =>
      value = value.copyWith(playState: PlayState.playing);

  @override
  Future<Duration?> get position async => value.position.value;

  @override
  Future<void> setPlaybackSpeed(double speed) async =>
      value = value.copyWith(playbackSpeed: speed);

  @override
  Future<void> setPosition(Duration position) async =>
      value = value.copyWith(position: position);
}
