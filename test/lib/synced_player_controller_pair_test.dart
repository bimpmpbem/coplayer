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

void main() {
  // test('', () {});

  const uninitialized2Minutes =
      GenericPlayerValue(duration: Duration(minutes: 2));
  const uninitialized9Minutes =
      GenericPlayerValue(duration: Duration(minutes: 9));
  const initialized2Minutes =
      GenericPlayerValue(duration: Duration(minutes: 2), isInitialized: true);
  const initialized9Minutes =
      GenericPlayerValue(duration: Duration(minutes: 9), isInitialized: true);
  const playing2Minutes = GenericPlayerValue(
    duration: Duration(minutes: 2),
    isInitialized: true,
    isPlaying: true,
    position: Duration(seconds: 1),
  );
  const playing9Minutes = GenericPlayerValue(
    duration: Duration(minutes: 9),
    isInitialized: true,
    isPlaying: true,
    position: Duration(seconds: 5),
  );

  setUp(() {});

  group('initialize', () {
    test('when all uninitialized, should initialize all', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized2Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
      );

      await pair.initialize();
      expect(pair.value.isInitialized, true);
      expect(pair.mainController.value, initialized2Minutes);
      expect(pair.secondaryController.value, initialized9Minutes);
    });
    test('when all initialized, should not break', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized2Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair.initialize();
      expect(pair.value.isInitialized, true);
      expect(pair.mainController.value, initialized2Minutes);
      expect(pair.secondaryController.value, initialized9Minutes);
    });
    test('when one controller initialized, should initialize the other',
        () async {
      final pair1 = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized2Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
      );
      final pair2 = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized2Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair1.initialize();
      await pair2.initialize();
      expect(pair1.value.isInitialized, true);
      expect(pair1.mainController.value, initialized2Minutes);
      expect(pair1.secondaryController.value, initialized9Minutes);
      expect(pair2.value.isInitialized, true);
      expect(pair2.mainController.value, initialized2Minutes);
      expect(pair2.secondaryController.value, initialized9Minutes);
    });
  });

  group('setPosition', () {
    late SyncedPlayerControllerPair mainBeforeSecondary;
    late SyncedPlayerControllerPair secondaryBeforeMain;
    setUp(() {
      mainBeforeSecondary = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized9Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
        offset: const Duration(minutes: 3),
      );
      secondaryBeforeMain = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized9Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
        offset: const Duration(minutes: -3),
      );
    });

    test('when not initialized should do nothing', () async {
      await mainBeforeSecondary.setPosition(const Duration(minutes: 5));
      expect(mainBeforeSecondary.mainController.value, uninitialized9Minutes);
      expect(
          mainBeforeSecondary.secondaryController.value, uninitialized9Minutes);

      await mainBeforeSecondary.setPosition(const Duration(minutes: 50));
      expect(mainBeforeSecondary.mainController.value, uninitialized9Minutes);
      expect(
          mainBeforeSecondary.secondaryController.value, uninitialized9Minutes);

      await mainBeforeSecondary.setPosition(const Duration(minutes: 0));
      expect(mainBeforeSecondary.mainController.value, uninitialized9Minutes);
      expect(
          mainBeforeSecondary.secondaryController.value, uninitialized9Minutes);
    });

    test('when value is set, should set positions of main and secondary',
        () async {
      await mainBeforeSecondary.initialize();

      await mainBeforeSecondary.setPosition(const Duration(minutes: 4));

      expect(mainBeforeSecondary.value.position, const Duration(minutes: 4));
      expect(mainBeforeSecondary.mainController.value.position,
          const Duration(minutes: 4));
      expect(mainBeforeSecondary.secondaryController.value.position,
          const Duration(minutes: 1));
    });

    test(
        'values that are too low or too high only in 1 controller, should get clamped and paused',
        () async {
      await mainBeforeSecondary.initialize();
      await secondaryBeforeMain.initialize();
      await mainBeforeSecondary.play();
      await secondaryBeforeMain.play();

      await mainBeforeSecondary.setPosition(const Duration(minutes: 1));
      expect(mainBeforeSecondary.value.position, const Duration(minutes: 1));
      expect(mainBeforeSecondary.mainController.value.position,
          const Duration(minutes: 1));
      expect(mainBeforeSecondary.secondaryController.value.position,
          const Duration(minutes: 0)); // clamped
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, false);

      await mainBeforeSecondary.setPosition(const Duration(minutes: 10));
      expect(mainBeforeSecondary.value.position, const Duration(minutes: 10));
      expect(mainBeforeSecondary.mainController.value.position,
          const Duration(minutes: 9)); // clamped
      expect(mainBeforeSecondary.secondaryController.value.position,
          const Duration(minutes: 7));
      expect(mainBeforeSecondary.mainController.value.isPlaying, false);

      await secondaryBeforeMain.setPosition(const Duration(minutes: -1));
      expect(secondaryBeforeMain.value.position, const Duration(minutes: -1));
      expect(secondaryBeforeMain.mainController.value.position,
          const Duration(minutes: 0)); // clamped
      expect(secondaryBeforeMain.secondaryController.value.position,
          const Duration(minutes: 2));
      expect(secondaryBeforeMain.mainController.value.isPlaying, false);

      await secondaryBeforeMain.setPosition(const Duration(minutes: 8));
      expect(secondaryBeforeMain.value.position, const Duration(minutes: 8));
      expect(secondaryBeforeMain.mainController.value.position,
          const Duration(minutes: 8));
      expect(secondaryBeforeMain.secondaryController.value.position,
          const Duration(minutes: 9)); // clamped
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, false);
    });

    test(
        'values that are too low or too high in both controllers, should get clamped and pause pair',
        () async {
      await mainBeforeSecondary.initialize();

      await mainBeforeSecondary.play();
      await mainBeforeSecondary.setPosition(const Duration(minutes: 50));
      expect(mainBeforeSecondary.value.position, const Duration(minutes: 12));
      expect(mainBeforeSecondary.value.isPlaying, false);
      expect(mainBeforeSecondary.mainController.value.isPlaying, false);
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, false);

      await mainBeforeSecondary.play();
      await mainBeforeSecondary.setPosition(const Duration(minutes: -50));
      expect(mainBeforeSecondary.value.position, const Duration(minutes: 0));
      expect(mainBeforeSecondary.value.isPlaying, false);
      expect(mainBeforeSecondary.mainController.value.isPlaying, false);
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, false);
    });

    test(
        'updating position with valid target should not change play/pause state',
        () async {
      await mainBeforeSecondary.initialize();

      await mainBeforeSecondary.play();
      await mainBeforeSecondary.setPosition(const Duration(minutes: 5));
      expect(mainBeforeSecondary.value.isPlaying, true);
      expect(mainBeforeSecondary.mainController.value.isPlaying, true);
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, true);

      await mainBeforeSecondary.pause();
      await mainBeforeSecondary.setPosition(const Duration(minutes: 6));
      expect(mainBeforeSecondary.value.isPlaying, false);
      expect(mainBeforeSecondary.mainController.value.isPlaying, false);
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, false);
    });

    test(
        'when paused controller gets valid position while pair is playing, '
        'it should resume playing', () async {
      await mainBeforeSecondary.initialize();
      await secondaryBeforeMain.initialize();
      await mainBeforeSecondary.play();
      await secondaryBeforeMain.play();

      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 1)); // too low for secondary
      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, true);

      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 10)); // too high for main
      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(mainBeforeSecondary.mainController.value.isPlaying, true);

      await secondaryBeforeMain
          .setPosition(const Duration(minutes: -1)); // too low for main
      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(mainBeforeSecondary.mainController.value.isPlaying, true);

      await secondaryBeforeMain
          .setPosition(const Duration(minutes: 8)); // too high for secondary
      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, true);
    });

    test(
        'when paused controller gets valid position while pair is paused, '
        'it should stay paused', () async {
      await mainBeforeSecondary.initialize();
      await secondaryBeforeMain.initialize();

      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 1)); // too low for secondary
      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(mainBeforeSecondary.secondaryController.value.isPlaying, false);

      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 10)); // too high for main
      await mainBeforeSecondary
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(mainBeforeSecondary.mainController.value.isPlaying, false);

      await secondaryBeforeMain
          .setPosition(const Duration(minutes: -1)); // too low for main
      await secondaryBeforeMain
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(secondaryBeforeMain.mainController.value.isPlaying, false);

      await secondaryBeforeMain
          .setPosition(const Duration(minutes: 8)); // too high for secondary
      await secondaryBeforeMain
          .setPosition(const Duration(minutes: 5)); // un-clamp
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, false);
    });
  });
  group('play', () {
    test('when not initialized should do nothing', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized2Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
      );

      await pair.play();
      expect(pair.mainController.value, uninitialized2Minutes);
      expect(pair.secondaryController.value, uninitialized9Minutes);
    });

    test('when both have valid position should play both', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized9Minutes),
        secondaryController: TestController(initialValue: initialized2Minutes),
      );

      await pair.initialize();
      await pair.setPosition(const Duration(minutes: 1));
      await pair.play();

      expect(pair.value.isPlaying, true);
      expect(pair.mainController.value.isPlaying, true);
      expect(pair.secondaryController.value.isPlaying, true);
    });
    test('when one has invalid position should play only valid', () {});
    test('when both already playing should do nothing', () {});
    test('when one already playing should play the other', () {});
  });
  group('pause', () {
    test('when not initialized should do nothing', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized2Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
      );

      await pair.pause();

      expect(pair.mainController.value, uninitialized2Minutes);
      expect(pair.secondaryController.value, uninitialized9Minutes);
    });

    test('when both playing should pause', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing9Minutes),
        secondaryController: TestController(initialValue: playing2Minutes),
      );

      await pair.initialize();
      await pair.pause();

      expect(pair.mainController.value.isPlaying, false);
      expect(pair.secondaryController.value.isPlaying, false);
    });
    test('when one playing should pause the other', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing9Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair.initialize();
      await pair.pause();

      expect(pair.mainController.value.isPlaying, false);
      expect(pair.secondaryController.value.isPlaying, false);
    });
    test('when none playing should do nothing', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized9Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair.pause();

      expect(pair.mainController.value.isPlaying, false);
      expect(pair.secondaryController.value.isPlaying, false);
    });
  });

  group('controller updates', () {
    test('when any position changed, should sync other positions', () {});
    test('when position synced and valid, should not change play state', () {});
    test(
        'when synced other position is too high/low, should get clamped/paused',
        () {});

    test('when playing and one is paused, should pause all', () {});
    test('when playing and one is buffering, should pause rest temporarily',
        () {});

    test('when paused and one is played, should play all', () {});
    test(
        'when paused and one is played while ended, should play from start of ended',
        () {});
    test(
        'when paused and one is played while other ended, should play only one',
        () {});

    test('when playing and one reaches end, other should keep playing', () {});
    test('when reached end of both controllers, should pause', () {});

    test('when duration of controller changes, should update pair duration',
        () {});

    test(
        'when both controllers are initialized, '
        'should set pair as initialized regardless of calls to initialize()',
        () {});

    test('when any playback speed changed, should sync all speeds', () {});
  });
}
