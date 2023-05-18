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
  const initialized2Minutes =
      GenericPlayerValue(duration: Duration(minutes: 2), isInitialized: true);
  const uninitialized9Minutes =
      GenericPlayerValue(duration: Duration(minutes: 9));
  const initialized9Minutes =
      GenericPlayerValue(duration: Duration(minutes: 9), isInitialized: true);

  setUp(() {});

  group('initialize', () {
    test('all uninitialized', () async {
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
    test('controllers initialized', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized2Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair.initialize();
      expect(pair.value.isInitialized, true);
      expect(pair.mainController.value, initialized2Minutes);
      expect(pair.secondaryController.value, initialized9Minutes);
    });
    test('one controller initialized', () async {
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
    test('all initialized', () async {
      final pair = SyncedPlayerControllerPair(
        mainController: TestController(initialValue: initialized2Minutes),
        secondaryController: TestController(initialValue: initialized9Minutes),
      );

      await pair.initialize();
      expect(pair.value.isInitialized, true);
      expect(pair.mainController.value, initialized2Minutes);
      expect(pair.secondaryController.value, initialized9Minutes);
    });
  });

  group('setPosition', () {
    group('pair', () {
      test('when not initialized should do nothing', () async {
        final pair = SyncedPlayerControllerPair(
          mainController: TestController(initialValue: uninitialized2Minutes),
          secondaryController:
              TestController(initialValue: uninitialized9Minutes),
        );

        await pair.setPosition(const Duration(minutes: 5));
        expect(pair.mainController.value, uninitialized2Minutes);
        expect(pair.secondaryController.value, uninitialized9Minutes);

        await pair.setPosition(const Duration(minutes: 50));
        expect(pair.mainController.value, uninitialized2Minutes);
        expect(pair.secondaryController.value, uninitialized9Minutes);

        await pair.setPosition(const Duration(minutes: 0));
        expect(pair.mainController.value, uninitialized2Minutes);
        expect(pair.secondaryController.value, uninitialized9Minutes);
      });

      group('playing', () {
        test('offset should be calculated relative to mainController',
            () async {
          final pair = SyncedPlayerControllerPair(
            mainController: TestController(initialValue: uninitialized2Minutes),
            secondaryController:
                TestController(initialValue: uninitialized9Minutes),
            offset: const Duration(minutes: 3),
          );

          await pair.initialize();
          await pair.play();

          await pair.setPosition(const Duration(minutes: 1));

          expect(pair.value.position, const Duration(minutes: 1));
          expect(
              pair.mainController.value.position, const Duration(minutes: 1));
          expect(pair.secondaryController.value.position,
              const Duration(minutes: 4));
        });

        test('when target valid for both should keep playing', () async {
          final pair = SyncedPlayerControllerPair(
            mainController: TestController(initialValue: uninitialized9Minutes),
            secondaryController:
                TestController(initialValue: uninitialized9Minutes),
            offset: const Duration(minutes: 3),
          );

          await pair.initialize();
          await pair.play();

          await pair.setPosition(const Duration(minutes: 1));

          expect(pair.value.isPlaying, true);
        });

        test('when target before main should clamp & pause main', () async {
          final pair = SyncedPlayerControllerPair(
            mainController: TestController(initialValue: uninitialized9Minutes),
            secondaryController:
                TestController(initialValue: uninitialized9Minutes),
            offset: const Duration(minutes: -3),
          );

          await pair.initialize();
          await pair.play();

          await pair.setPosition(const Duration(minutes: -1));

          expect(pair.value.isPlaying, true);
          expect(pair.mainController.value.isPlaying, false);
          expect(pair.secondaryController.value.isPlaying, true);
          expect(pair.mainController.value.position, Duration.zero);
          expect(pair.secondaryController.value.position,
              const Duration(minutes: 2));
        });
        test('when target before secondary should clamp & pause secondary',
            () async {
          final pair = SyncedPlayerControllerPair(
            mainController: TestController(initialValue: uninitialized2Minutes),
            secondaryController:
                TestController(initialValue: uninitialized9Minutes),
            offset: const Duration(minutes: 3),
          );

          await pair.initialize();
          await pair.play();

          await pair.setPosition(const Duration(minutes: 1));

          expect(pair.value.isPlaying, true);
          expect(pair.mainController.value.isPlaying, true);
          expect(pair.secondaryController.value.isPlaying, false);
          expect(
              pair.mainController.value.position, const Duration(minutes: 2));
          expect(pair.secondaryController.value.position, Duration.zero);
        });
      });
      group('paused', () {
        test('when target valid for both should keep playing', () async {
          final pair = SyncedPlayerControllerPair(
            mainController: TestController(initialValue: uninitialized2Minutes),
            secondaryController:
                TestController(initialValue: uninitialized9Minutes),
          );

          await pair.initialize();

          await pair.setPosition(const Duration(minutes: 1));

          expect(pair.value.isPlaying, false);
        });
      });

      test('when target before secondary should only play main', () {});
      test('when target before both should clamp to earliest', () {});
      test('when target after main should only play secondary', () {});
      test('when target after secondary should only play main', () {});
      test('when target after both should clamp to latest', () {});
      test(
          'when playing and a previously invalid target becomes valid'
          ' should resume play',
          () {});

      test('offset should be calculated relative to mainController', () {});
    });
    group('controller in pair', () {
      test('when both playing should pause', () {});
      test('when one playing should pause the other', () {});
      test('when none playing should do nothing', () {});
    });
  });
  group('play', () {
    group('pair', () {
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
          secondaryController:
              TestController(initialValue: initialized2Minutes),
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
      test('when not initialized should do nothing', () async {
        final pair = SyncedPlayerControllerPair(
          mainController: TestController(initialValue: uninitialized2Minutes),
          secondaryController:
              TestController(initialValue: uninitialized9Minutes),
        );

        await pair.pause();
        ;
        expect(pair.mainController.value, uninitialized2Minutes);
        expect(pair.secondaryController.value, uninitialized9Minutes);
      });

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
