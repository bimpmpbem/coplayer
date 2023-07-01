import 'package:coplayer/duration_range.dart';
import 'package:coplayer/synced_player.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_controller.dart';

void main() {
  // test('', () {});

  final uninitialized2Minutes =
      GenericPlayerValue(positionRange: const Duration(minutes: 2).asRange());
  final uninitialized9Minutes =
      GenericPlayerValue(positionRange: const Duration(minutes: 9).asRange());
  final initialized2Minutes = GenericPlayerValue(
      positionRange: const Duration(minutes: 2).asRange(), isInitialized: true);
  final initialized9Minutes = GenericPlayerValue(
      positionRange: const Duration(minutes: 9).asRange(), isInitialized: true);
  final playing2Minutes = GenericPlayerValue(
    positionRange: const Duration(minutes: 2).asRange(),
    isInitialized: true,
    isPlaying: true,
    position: const Duration(seconds: 1),
  );
  final playing9Minutes = GenericPlayerValue(
    positionRange: const Duration(minutes: 9).asRange(),
    isInitialized: true,
    isPlaying: true,
    position: const Duration(seconds: 5),
  );

  late SyncedPlayerControllerPair mainBeforeSecondary;
  late SyncedPlayerControllerPair secondaryBeforeMain;
  setUp(() {
    mainBeforeSecondary = SyncedPlayerControllerPair(
      mainController: TestController(initialValue: uninitialized9Minutes),
      secondaryController: TestController(initialValue: uninitialized9Minutes),
      offset: const Duration(minutes: 3),
    );
    secondaryBeforeMain = SyncedPlayerControllerPair(
      mainController: TestController(initialValue: uninitialized9Minutes),
      secondaryController: TestController(initialValue: uninitialized9Minutes),
      offset: const Duration(minutes: -3),
    );
  });

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

    test('when main is playing, should play other', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing2Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair.initialize();
      expect(pair.value.isPlaying, true);
      expect(pair.mainController.value.isPlaying, true);
      expect(pair.secondaryController.value.isPlaying, true);
    });
    test('when main is paused, should pause other', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized2Minutes),
        secondaryController: TestController(initialValue: playing9Minutes),
      );

      await pair.initialize();
      expect(pair.value.isPlaying, false);
      expect(pair.mainController.value.isPlaying, false);
      expect(pair.secondaryController.value.isPlaying, false);
    });
    test('when any is buffering, should be buffering', () async {
      final pair1 = SyncedPlayerControllerPair(
        mainController: TestController(
            initialValue: playing2Minutes.copyWith(isBuffering: true)),
        secondaryController: TestController(initialValue: playing9Minutes),
      );
      final pair2 = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing2Minutes),
        secondaryController: TestController(
            initialValue: playing9Minutes.copyWith(isBuffering: true)),
      );
      final pair3 = SyncedPlayerControllerPair(
        mainController: TestController(
            initialValue: playing2Minutes.copyWith(isBuffering: true)),
        secondaryController: TestController(
            initialValue: playing9Minutes.copyWith(isBuffering: true)),
      );

      await pair1.initialize();

      expect(pair1.value.isBuffering, true);
      expect(pair1.mainController.value.isPlaying, true);
      expect(pair1.secondaryController.value.isPlaying, false);

      await pair2.initialize();

      expect(pair2.value.isBuffering, true);
      expect(pair2.mainController.value.isPlaying, false);
      expect(pair2.secondaryController.value.isPlaying, true);

      await pair3.initialize();

      expect(pair3.value.isBuffering, true);
      // pausing others does not matter when both are buffering
      // expect(pair3.mainController.value.isPlaying, false);
      // expect(pair3.secondaryController.value.isPlaying, false);
    });
    test('playback speed should match main', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing2Minutes),
        secondaryController: TestController(initialValue: playing9Minutes),
      );

      pair.mainController.setPlaybackSpeed(1.2);
      pair.secondaryController.setPlaybackSpeed(1.2);
      await pair.initialize();

      expect(pair.value.playbackSpeed, 1.2);
      expect(pair.mainController.value.playbackSpeed, 1.2);
      expect(pair.secondaryController.value.playbackSpeed, 1.2);
    });
    test('playback position should sync to main', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing9Minutes),
        secondaryController: TestController(initialValue: playing9Minutes),
        offset: const Duration(minutes: 3),
      );

      pair.mainController.setPosition(const Duration(minutes: 4));
      pair.secondaryController.setPosition(const Duration(minutes: 8));
      await pair.initialize();

      expect(pair.value.position, const Duration(minutes: 4));
      expect(pair.mainController.value.position, const Duration(minutes: 4));
      expect(
          pair.secondaryController.value.position, const Duration(minutes: 1));
    });

    test('start/end position should include main and secondary', () async {
      await mainBeforeSecondary.initialize();

      expect(mainBeforeSecondary.value.positionRange,
          const Duration(minutes: 0).rangeTo(const Duration(minutes: 12)));

      await secondaryBeforeMain.initialize();

      expect(secondaryBeforeMain.value.positionRange,
          const Duration(minutes: -3).rangeTo(const Duration(minutes: 9)));
    });
  });

  group('setPosition', () {
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

    test('values that are too high or too low, should get clamped', () async {
      await mainBeforeSecondary.initialize();

      // playing too high
      await mainBeforeSecondary.play();
      await mainBeforeSecondary.setPosition(const Duration(minutes: 50));

      expect(mainBeforeSecondary.value.position, const Duration(minutes: 12));

      // playing too low
      await mainBeforeSecondary.play();
      await mainBeforeSecondary.setPosition(const Duration(minutes: -50));

      expect(mainBeforeSecondary.value.position, const Duration(minutes: 0));
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
    test('when both already playing should not break', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: playing9Minutes),
        secondaryController: TestController(initialValue: playing9Minutes),
      );

      await pair.initialize();
      await pair.play();

      expect(pair.value.isPlaying, true);
      expect(pair.mainController.value.isPlaying, true);
      expect(pair.secondaryController.value.isPlaying, true);
    });
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

  group('dispose', () {
    test('when disposed, calls should throw', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized2Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
      );

      await pair.initialize();

      await pair.dispose();

      expect(() async => pair.play(), throwsFlutterError);
    });

    test('when disposed twice, should not break', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: uninitialized2Minutes),
        secondaryController:
            TestController(initialValue: uninitialized9Minutes),
      );

      await pair.initialize();
      await pair.dispose();

      expect(() async => pair.dispose(), returnsNormally);
    });
    test('when disposed, initialization should not work', () async {
      // TODO
    });
  });

  group('controller updates', () {
    test('when any position changed, should sync other positions', () async {
      await secondaryBeforeMain.initialize();

      await secondaryBeforeMain.mainController
          .setPosition(const Duration(minutes: 1));

      expect(secondaryBeforeMain.value.position, const Duration(minutes: 1));
      expect(secondaryBeforeMain.mainController.value.position,
          const Duration(minutes: 1));
      expect(secondaryBeforeMain.secondaryController.value.position,
          const Duration(minutes: 4));

      await secondaryBeforeMain.secondaryController
          .setPosition(const Duration(minutes: 5));

      expect(secondaryBeforeMain.value.position, const Duration(minutes: 2));
      expect(secondaryBeforeMain.mainController.value.position,
          const Duration(minutes: 2));
      expect(secondaryBeforeMain.secondaryController.value.position,
          const Duration(minutes: 5));
    });
    test('when position synced and valid, should not change play state',
        () async {
      await secondaryBeforeMain.initialize();

      await secondaryBeforeMain.mainController
          .setPosition(const Duration(minutes: 1));

      expect(secondaryBeforeMain.value.isPlaying, false);
      expect(secondaryBeforeMain.mainController.value.isPlaying, false);
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, false);

      await secondaryBeforeMain.play();
      await secondaryBeforeMain.secondaryController
          .setPosition(const Duration(minutes: 5));

      expect(secondaryBeforeMain.value.isPlaying, true);
      expect(secondaryBeforeMain.mainController.value.isPlaying, true);
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, true);
    });

    test('when playing and one is paused, should pause all', () async {
      await secondaryBeforeMain.initialize();
      await secondaryBeforeMain.setPosition(const Duration(minutes: 0));

      await secondaryBeforeMain.play();
      await secondaryBeforeMain.mainController.pause();

      expect(secondaryBeforeMain.value.isPlaying, false);
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, false);

      await secondaryBeforeMain.play();
      await secondaryBeforeMain.secondaryController.pause();

      expect(secondaryBeforeMain.value.isPlaying, false);
      expect(secondaryBeforeMain.mainController.value.isPlaying, false);
    });
    test('when playing and one is buffering, should pause rest temporarily',
        () async {
      await secondaryBeforeMain.initialize();
      await secondaryBeforeMain.play();

      secondaryBeforeMain.mainController.value =
          secondaryBeforeMain.mainController.value.copyWith(isBuffering: true);

      expect(secondaryBeforeMain.value.isPlaying, true);
      expect(secondaryBeforeMain.value.isBuffering, true);
      expect(secondaryBeforeMain.mainController.value.isPlaying, true);
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, false);

      secondaryBeforeMain.secondaryController.value = secondaryBeforeMain
          .secondaryController.value
          .copyWith(isBuffering: true);

      expect(secondaryBeforeMain.value.isPlaying, true);
      expect(secondaryBeforeMain.value.isBuffering, true);
      // pausing others does not matter when both are buffering
      // expect(secondaryBeforeMain.mainController.value.isPlaying, false);
      // expect(secondaryBeforeMain.secondaryController.value.isPlaying, false);

      secondaryBeforeMain.mainController.value =
          secondaryBeforeMain.mainController.value.copyWith(isBuffering: false);

      expect(secondaryBeforeMain.value.isPlaying, true);
      expect(secondaryBeforeMain.value.isBuffering, true);
      expect(secondaryBeforeMain.mainController.value.isPlaying, false);
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, true);

      secondaryBeforeMain.secondaryController.value = secondaryBeforeMain
          .secondaryController.value
          .copyWith(isBuffering: false);

      expect(secondaryBeforeMain.value.isPlaying, true);
      expect(secondaryBeforeMain.value.isBuffering, false);
      expect(secondaryBeforeMain.mainController.value.isPlaying, true);
      expect(secondaryBeforeMain.secondaryController.value.isPlaying, true);
    });

    test('when paused and one is played, should play all', () async {});
    test(
        'when paused and one is played while other ended, should play only one',
        () async {});

    test('when playing and one reaches end, other should keep playing',
        () async {});
    test('when reached end of both controllers, should pause', () async {});

    test('when start/end position of controller changes, should update pair',
        () async {
      final main = TestController(
        initialValue: const GenericPlayerValue(
            positionRange:
                DurationRange(Duration(minutes: 0), Duration(minutes: 8))),
      );
      final secondary = TestController(
        initialValue: GenericPlayerValue(
            positionRange:
                const Duration(minutes: 2).rangeTo(const Duration(minutes: 6))),
      );
      final pair = SyncedPlayerControllerPair(
          mainController: main, secondaryController: secondary);

      await pair.initialize();

      main.value = main.value.copyWith(
          positionRange:
              const DurationRange(Duration(minutes: 1), Duration(minutes: 8)));

      expect(pair.value.positionRange,
          const DurationRange(Duration(minutes: 1), Duration(minutes: 8)));

      main.value = main.value.copyWith(
          positionRange:
              const DurationRange(Duration(minutes: 3), Duration(minutes: 8)));

      expect(pair.value.positionRange,
          const DurationRange(Duration(minutes: 2), Duration(minutes: 8)));

      secondary.value = secondary.value.copyWith(
          positionRange:
              const DurationRange(Duration(minutes: 4), Duration(minutes: 6)));

      expect(pair.value.positionRange,
          const DurationRange(Duration(minutes: 3), Duration(minutes: 8)));

      main.value = main.value.copyWith(
          positionRange:
              const DurationRange(Duration(minutes: 3), Duration(minutes: 9)));

      expect(pair.value.positionRange,
          const DurationRange(Duration(minutes: 3), Duration(minutes: 9)));

      secondary.value = secondary.value.copyWith(
          positionRange:
              const DurationRange(Duration(minutes: 4), Duration(minutes: 20)));

      expect(pair.value.positionRange,
          const DurationRange(Duration(minutes: 3), Duration(minutes: 20)));
    });

    test(
        'when both controllers are initialized, '
        'should set pair as initialized regardless of calls to initialize()',
        () async {});

    test(
        'when any playback speed changed, should sync all speeds', () async {});
  });
}
