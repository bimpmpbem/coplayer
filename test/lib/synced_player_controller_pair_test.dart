import 'package:coplayer/synced_player.dart';
import 'package:flutter_test/flutter_test.dart';

class TestController extends GenericPlayerController {
  TestController({
    GenericPlayerValue initialValue =
        const GenericPlayerValue(duration: Duration.zero),
  }) : super() {
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

  const value1Minute = GenericPlayerValue(duration: Duration(minutes: 1));
  const value2Minutes = GenericPlayerValue(duration: Duration(minutes: 2));

  setUp(() {});

  test('uninitialized controller should not do anything', () async {
    final pair = SyncedPlayerControllerPair(
      mainController: TestController(initialValue: value1Minute),
      secondaryController: TestController(initialValue: value2Minutes),
    );

    await pair.play();
    expect(pair.mainController.value, value1Minute);
    expect(pair.secondaryController.value, value2Minutes);
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
