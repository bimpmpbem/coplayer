import 'package:coplayer/duration_range.dart';
import 'package:coplayer/generic_player_state.dart';
import 'package:coplayer/synced_player_group_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_controller.dart';

void main() {
  late GenericPlayerState longContentState;

  setUp(() {
    longContentState = GenericPlayerState.now(
        positionRange:
            const DurationRange(Duration.zero, Duration(minutes: 10)));
  });

  // TODO test entire states instead of partially w/ some fields

  test('initializing group should initialize children', () async {
    final someGroup = SyncedPlayerGroupController(children: [
      SyncedController(
        TestController(initialValue: longContentState),
        offset: const Duration(minutes: -3),
      ),
      SyncedController(
        TestController(initialValue: longContentState),
      ),
      SyncedController(
        TestController(initialValue: longContentState),
      ),
      SyncedController(
        TestController(initialValue: longContentState),
        offset: const Duration(minutes: 3),
      ),
    ]);

    // an already initialized child shouldn't affect anything
    await someGroup.children[2].controller.initialize();

    await someGroup.initialize();

    expect(someGroup.value.playState.value, PlayState.paused);
    expect(
      someGroup.children.map((e) => e.controller.value.playState.value),
      everyElement(PlayState.paused),
    );
  });
  // test('initializing group should sync correctly', () async {
  //   throw UnimplementedError();
  // });
  // test('uninitialized group should do nothing', () async {
  //   throw UnimplementedError();
  // });

  group('sync update states correctly', () {
    test('paused child position changes in bounds', () async {
      final earlyChild = TestController(initialValue: longContentState);
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          earlyChild,
          offset: const Duration(minutes: -3),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 3),
        ),
      ]);

      await someGroup.initialize();

      await earlyChild.setPosition(const Duration(minutes: 8));
      await someGroup.sync();

      expect(
        someGroup.value.position.value,
        const Duration(minutes: 5),
      );
      expect(
        someGroup.children[0].controller.value.position.value,
        const Duration(minutes: 8),
      );
      expect(
        someGroup.children[1].controller.value.position.value,
        const Duration(minutes: 5),
      );
      expect(
        someGroup.children[2].controller.value.position.value,
        const Duration(minutes: 2),
      );
      expect(
        someGroup.children.map((e) => e.controller.value.playState.value),
        everyElement(PlayState.paused),
      );
    });
    // test('paused child position changes out of bounds', () async {
    //   throw UnimplementedError();
    // });
    // test('playing child position changes in bounds', () async {
    //   throw UnimplementedError();
    // });
    // test('playing child position changes out of bounds', () async {
    //   throw UnimplementedError();
    // });

    test('parent position changes in bounds of children', () async {
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -3),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 3),
        ),
      ]);

      await someGroup.initialize();

      await someGroup.setPosition(const Duration(minutes: 5));
      await someGroup.sync();

      expect(
        someGroup.value.position.value,
        const Duration(minutes: 5),
      );
      expect(
        someGroup.children[0].controller.value.position.value,
        const Duration(minutes: 8),
      );
      expect(
        someGroup.children[1].controller.value.position.value,
        const Duration(minutes: 5),
      );
      expect(
        someGroup.children[2].controller.value.position.value,
        const Duration(minutes: 2),
      );
    });
    test('parent position changes out of bounds of child', () async {
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -9),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 3),
        ),
      ]);

      await someGroup.initialize();

      await someGroup.setPosition(const Duration(minutes: 2));

      expect(someGroup.children[0].controller.value.position.value,
          const Duration(minutes: 10));
      expect(someGroup.children[1].controller.value.position.value,
          const Duration(minutes: 0));

      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.paused,
      );
    });

    test('paused group child starts playing in bounds', () async {
      final childInRange = TestController(initialValue: longContentState);
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -99),
        ),
        SyncedController(
          childInRange,
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 99),
        ),
      ]);

      await someGroup.initialize();

      await childInRange.play();
      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.playing);
      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.playing,
      );
      expect(
        someGroup.children[2].controller.value.playState.value,
        PlayState.paused,
      );
    });
    test('paused group child starts playing out of bounds', () async {
      final childOutsideRange = TestController(initialValue: longContentState);
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          childOutsideRange,
          offset: const Duration(minutes: -99),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 99),
        ),
      ]);

      await someGroup.initialize();

      await childOutsideRange.play();
      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.paused);
      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[2].controller.value.playState.value,
        PlayState.paused,
      );
    });
    test('paused group starts playing out of bounds for some', () async {
      final childInRange = TestController(initialValue: longContentState);
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -99),
        ),
        SyncedController(
          childInRange,
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 99),
        ),
      ]);

      await someGroup.initialize();

      await someGroup.play();
      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.playing);
      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.playing,
      );
      expect(
        someGroup.children[2].controller.value.playState.value,
        PlayState.paused,
      );
    });
    test('ended group starts playing again', () async {
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -3),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 3),
        ),
      ]);

      await someGroup.initialize();

      await someGroup
          .setPosition(someGroup.value.positionRange.value.endInclusive);
      await someGroup.play();
      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.playing);
      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.playing,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.playing,
      );
      expect(
        someGroup.children[2].controller.value.playState.value,
        PlayState.paused,
      );

      expect(
        someGroup.value.position.value.inMilliseconds,
        closeTo(0, 200),
      );
    });

    test('playing group child reaches end', () async {
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -3),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 3),
        ),
      ]);

      await someGroup.initialize();
      await someGroup.play();
      await someGroup.sync();

      await someGroup.setPosition(const Duration(minutes: 8));

      expect(someGroup.value.playState.value, PlayState.playing);
      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.playing,
      );
      expect(
        someGroup.children[2].controller.value.playState.value,
        PlayState.playing,
      );
    });
    test('playing group child is paused in bounds', () async {
      final childInRange = TestController(initialValue: longContentState);
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -99),
        ),
        SyncedController(
          childInRange,
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 99),
        ),
      ]);

      await someGroup.initialize();
      await childInRange.play();
      await someGroup.sync();

      await childInRange.pause();
      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.paused);
      expect(
        someGroup.children.map((e) => e.controller.value.playState.value),
        everyElement(PlayState.paused),
      );
    });
    // test('playing group child is paused out of bounds', () async {
    //   throw UnimplementedError();
    // });

    // test('playing group child out of bounds gets position in bounds', () async {
    //   // should resume playback, etc.
    //   throw UnimplementedError();
    // });
    // test('paused group child out of bounds gets position in bounds', () async {
    //   // should stay paused, etc.
    //   throw UnimplementedError();
    // });

    // test('playing group played again', () async {
    //   throw UnimplementedError();
    // });
    // test('buffering group played again', () async {
    //   throw UnimplementedError();
    // });
    // test('paused group paused again', () async {
    //   throw UnimplementedError();
    // });

    // test('buffering group paused', () async {
    //   throw UnimplementedError();
    // });
    // test('buffering group changed position', () async {
    //   throw UnimplementedError();
    // });

    // test('playing group child is paused out of bounds', () async {
    //   throw UnimplementedError();
    // });

    test('playing group child is buffering', () async {
      final bufferingChild = TestController(initialValue: longContentState);
      final someGroup = SyncedPlayerGroupController(children: [
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: -3),
        ),
        SyncedController(
          bufferingChild,
        ),
        SyncedController(
          TestController(initialValue: longContentState),
          offset: const Duration(minutes: 3),
        ),
      ]);

      await someGroup.initialize();
      await someGroup.setPosition(const Duration(minutes: 4));
      await someGroup.play();
      await someGroup.sync();

      bufferingChild.value =
          bufferingChild.value.copyWith(playState: PlayState.playingBuffering);

      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.playingBuffering);
      expect(
        someGroup.children[0].controller.value.playState.value,
        PlayState.paused,
      );
      expect(
        someGroup.children[1].controller.value.playState.value,
        PlayState.playingBuffering,
      );
      expect(
        someGroup.children[2].controller.value.playState.value,
        PlayState.paused,
      );

      bufferingChild.value =
          bufferingChild.value.copyWith(playState: PlayState.playing);

      await someGroup.sync();

      expect(someGroup.value.playState.value, PlayState.playing);
      expect(
        someGroup.children.map((e) => e.controller.value.playState.value),
        everyElement(PlayState.playing),
      );
    });

    // test('playing group position at end', () async {
    //   throw UnimplementedError();
    // });
    // test('buffering group position at end', () async {
    //   throw UnimplementedError();
    // });

    // test('group child positionRange changed', () async {
    //   throw UnimplementedError();
    // });
    //
    // test('when playState changes, position should get refreshed', () async {
    //   throw UnimplementedError();
    // });

    // TODO speed
  });

  // TODO automatic progress even when no children in bounds (timer)

  // TODO dispose

  test('positionRange should fit all children', () async {
    final someGroup = SyncedPlayerGroupController(children: [
      SyncedController(
        TestController(initialValue: longContentState),
        offset: const Duration(minutes: -3),
      ),
      SyncedController(
        TestController(initialValue: longContentState),
      ),
      SyncedController(
        TestController(initialValue: longContentState),
        offset: const Duration(minutes: 3),
      ),
    ]);

    await someGroup.initialize();
    await someGroup.sync();

    expect(someGroup.value.positionRange.value,
        const DurationRange(Duration(minutes: -3), Duration(minutes: 13)));
  });
}
