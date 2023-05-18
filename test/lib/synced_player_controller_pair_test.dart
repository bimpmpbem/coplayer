import 'package:coplayer/synced_player.dart';
import 'package:flutter_test/flutter_test.dart';

class TestController extends GenericPlayerController {
  TestController({
    required Duration duration,
    GenericPlayerValue initialValue =
        const GenericPlayerValue(duration: Duration.zero),
  }) : super(initialDuration: duration) {
    value = initialValue;
  }

  @override
  Future<void> initialize() async => value.copyWith(isInitialized: true);

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

void main() {
  // test('', () {});

  setUp(() {});

  test('uninitialized controller should not do anything', () async {
    final pair = SyncedPlayerControllerPair(
      mainController: TestController(duration: const Duration(minutes: 1)),
      secondaryController: TestController(duration: const Duration(minutes: 2)),
    );

    await pair.play();
    expect(pair.mainController.value,
        const GenericPlayerValue(duration: Duration(minutes: 1)));
    expect(pair.secondaryController.value.isPlaying,
        const GenericPlayerValue(duration: Duration(minutes: 2)));
  });

  group('play', () {
    group('pair', () {
      test('when both have valid position should play both', () {});
      test('when one has invalid position should play only valid', () {});
      test('when both already playing should do nothing', () {});
      test('when one already playing should play the other', () {});
    });
    group('controller in pair', () {
      test('when both have valid position should play both', () {});
      test('when other has invalid position should play only valid', () {});
      test(
          'when played has invalid position should play from beginning', () {});
      test('when both already playing should do nothing', () {});
      test('when only one already playing should play the other', () {});
    });
  });
  group('pause', () {
    group('pair', () {
      test('when both playing should pause', () {});
      test('when one playing should pause the other', () {});
      test('when none playing should do nothing', () {});
    });
    group('controller in pair', () {
      test('when both playing should pause', () {});
      test('when one playing should pause the other', () {});
      test('when none playing should do nothing', () {});
    });
  });
}
