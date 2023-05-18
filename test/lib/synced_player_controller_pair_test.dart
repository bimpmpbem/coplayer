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

  const uninitialized2Minutes =
      GenericPlayerValue(duration: Duration(minutes: 2));
  const initialized2Minutes =
      GenericPlayerValue(duration: Duration(minutes: 2), isInitialized: true);
  const uninitialized9Minutes =
      GenericPlayerValue(duration: Duration(minutes: 9));
  const initialized9Minutes =
      GenericPlayerValue(duration: Duration(minutes: 9), isInitialized: true);

  setUp(() {});

  test('uninitialized controller should not do anything', () async {
    final pair = SyncedPlayerControllerPair(
      mainController: TestController(initialValue: uninitialized2Minutes),
      secondaryController: TestController(initialValue: uninitialized9Minutes),
    );

    await pair.play();
    await pair.pause();
    await pair.setPosition(const Duration(minutes: 5));
    await pair.setPosition(const Duration(minutes: 50));
    await pair.setPosition(const Duration(minutes: 0));
    expect(pair.mainController.value, uninitialized2Minutes);
    expect(pair.secondaryController.value, uninitialized9Minutes);
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
