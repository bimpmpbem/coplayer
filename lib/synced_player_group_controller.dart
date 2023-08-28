import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dartx/dartx.dart';
import 'package:mutex/mutex.dart';

import 'duration_range.dart';
import 'generic_player_state.dart';
import 'synced_player.dart';

/// Configures a [GenericPlayerController] to be able to be managed by a
/// [SyncedPlayerGroupController].
class SyncedController {
  final GenericPlayerController controller;
  final Duration offset;

  // TODO speed?
  final String? name;

  const SyncedController(
    this.controller, {
    this.offset = Duration.zero,
    this.name,
  });

  Duration get estimatedNormalizedPosition =>
      controller.value.estimatedPosition + offset;
}

/// A group of [GenericPlayerController]s, which are kept in sync with each
/// other.
///
/// All the controllers' states will stay in sync, while applying their
/// respective configurations.
///
/// The group's positionRange will start at the earliest of the controllers'
/// start position, and end at the latest of the controllers' end position,
/// after applying their configurations.
/// This means that position values can be negative, and there might be
/// positions which are out of bounds for all of the controllers
/// ('holes' in playback).
class SyncedPlayerGroupController extends GenericPlayerController {
  // TODO make immutable from outside the class, or allow adding/removing children properly
  final List<SyncedController> children;
  Duration marginOfError;

  SyncedPlayerGroupController({
    required this.children,
    this.marginOfError = const Duration(milliseconds: 200),
  });

  final Mutex _syncMutex = Mutex();
  bool _disposed = false;

  // TODO add Logger

  @override
  Future<void> initialize() async {
    if (value.playState.value != PlayState.uninitialized || _disposed) return;

    if (kDebugMode) {
      addListener(() {
        debugPrint("value changed: ${value.toStringCompact()}");
      });
    }

    // initialize children
    for (final child in children) {
      if (child.controller.value.playState.value == PlayState.uninitialized) {
        await child.controller.initialize();
      }
      child.controller.addListener(sync);
    }

    value = value.copyWith(playState: PlayState.paused);

    // initial sync
    await sync();
  }

  @override
  Future<void> dispose() async {
    if (value.playState.value == PlayState.uninitialized || _disposed) return;

    for (final child in children) {
      child.controller.removeListener(sync);
    }
    _disposed = true;

    super.dispose();
  }

  Future<void> disposeAll() async {
    await Future.wait(children.map((e) async => e.controller.dispose));
    await dispose();
  }

  @override
  Future<void> play() async {
    if (value.playState.value != PlayState.paused) return;

    value = value.copyWith(
      playState: PlayState.playing,
      position: value.position.value, // needed for estimations to work
    );

    await sync();
  }

  @override
  Future<void> pause() async {
    if (value.playState.value != PlayState.playing &&
        value.playState.value != PlayState.playingBuffering) return;

    value = value.copyWith(playState: PlayState.paused);

    await sync();
  }

  @override
  Future<Duration?> get position async {
    if (value.playState.value == PlayState.uninitialized || _disposed) {
      return null;
    }

    return value.estimatedPosition;
  }

  @override
  Future<void> setPlaybackSpeed(double speed) {
    // TODO: implement setPlaybackSpeed
    throw UnimplementedError();
  }

  @override
  Future<void> setPosition(Duration position) async {
    if (value.playState.value == PlayState.uninitialized || _disposed) return;

    final clampedPosition = position.clampToRange(value.positionRange.value);

    value = value.copyWith(position: clampedPosition);

    await sync();
  }

  Future<void> _syncFromChildren() async {
    // TODO add caching? there might be race conditions with `controller.value`

    final earliestStart = children
        .map((child) =>
            child.controller.value.positionRange.value.start + child.offset)
        .min();
    final latestEnd = children
        .map((child) =>
            child.controller.value.positionRange.value.endInclusive +
            child.offset)
        .max();

    final totalRange = DurationRange(
      earliestStart ?? Duration.zero,
      latestEnd ?? Duration.zero,
    );

    // positionRange
    if (value.positionRange.value != totalRange) {
      debugPrint('positionRange changed to $totalRange');
      value = value.copyWith(positionRange: totalRange);
    }

    // position
    final newestPosition = children
        .sortedByDescending(
            (child) => child.controller.value.position.timestamp)
        .filterNot((child) =>
            child.controller.value.atEnd || child.controller.value.atStart)
        .firstOrNullWhere((child) => child.controller.value.position.timestamp
            .isAfter(value.position.timestamp))
        ?.estimatedNormalizedPosition;
    if (newestPosition != null) {
      debugPrint('position changed to $newestPosition');
      value = value.copyWith(position: newestPosition);
    }

    // playState
    final anyBuffering = children.any((child) =>
        child.controller.value.playState.value == PlayState.playingBuffering);
    final sortedByPlayState = children
        // ignore invalid states
        .filterNot((child) => !child.controller.value.positionRange.value
            .contains(value.estimatedPosition - child.offset))
        .sortedByDescending(
            (child) => child.controller.value.playState.timestamp);

    //  playing -> buffering
    if (value.playState.value == PlayState.playing && anyBuffering) {
      debugPrint('playState changed: playing -> buffering');
      value = value.copyWith(playState: PlayState.playingBuffering);
    }
    //  buffering -> playing
    else if (value.playState.value == PlayState.playingBuffering &&
        !anyBuffering) {
      debugPrint('playState changed: buffering -> playing');
      value = value.copyWith(playState: PlayState.playing);
    }

    final playingIsNewest =
        sortedByPlayState.firstOrNull?.controller.value.playState.value ==
                PlayState.playing &&
            sortedByPlayState.firstOrNull?.controller.value.playState.timestamp
                    .isAfter(value.playState.timestamp) ==
                true;
    final pausedIsNewest =
        sortedByPlayState.firstOrNull?.controller.value.playState.value ==
                PlayState.paused &&
            sortedByPlayState.firstOrNull?.controller.value.playState.timestamp
                    .isAfter(value.playState.timestamp) ==
                true;
    //  paused -> playing
    if (value.playState.value == PlayState.paused && playingIsNewest) {
      debugPrint('playState changed: paused -> playing');
      value = value.copyWith(
        playState: PlayState.playing,
        position: value.position.value, // needed for correct estimations
      );
    }
    //  playing -> paused
    else if (value.playState.value == PlayState.playing && pausedIsNewest) {
      debugPrint('playState changed: playing -> paused');
      value = value.copyWith(playState: PlayState.paused);
    }

    //  buffering -> paused
    //   does not happen automatically from children

    // TODO speed
  }

  Future<void> _syncToChildren() async {
    final targetPosition = value.estimatedPosition;

    // TODO check if any child is disposed?

    // children from parent
    for (final (index, child) in children.indexed) {
      final childValue = child.controller.value;

      final childPosition = childValue.estimatedPosition;
      final childTargetPosition = targetPosition - child.offset;
      final childTargetPositionRange =
          childTargetPosition.addMargin(marginOfError);

      final childTargetInBounds =
          childTargetPosition.inRange(childValue.positionRange.value);

      // setPosition in range
      if (childPosition.inRange(childTargetPositionRange) == false &&
          childTargetInBounds) {
        debugPrint('child #$index position set to $childTargetPosition');
        await child.controller.setPosition(childTargetPosition);
      }
      // setPosition clamp to end
      else if (!childValue.atEnd &&
          childTargetPosition > childValue.positionRange.value.endInclusive) {
        debugPrint(
            'child #$index position clamped to ${childValue.positionRange.value.endInclusive}');
        await child.controller
            .setPosition(childValue.positionRange.value.endInclusive);
      }
      // setPosition clamp to start
      else if (!childValue.atStart &&
          childTargetPosition < childValue.positionRange.value.start) {
        debugPrint(
            'child #$index position clamped to ${childValue.positionRange.value.start}');
        await child.controller
            .setPosition(childValue.positionRange.value.start);
      }

      // play
      if (value.playState.value == PlayState.playing &&
          childValue.playState.value == PlayState.paused &&
          childTargetInBounds) {
        debugPrint('child #$index played');
        await child.controller.play();
      }

      // pause when paused/buffering
      if ((value.playState.value == PlayState.paused ||
              value.playState.value == PlayState.playingBuffering) &&
          childValue.playState.value == PlayState.playing) {
        debugPrint('child #$index paused');
        await child.controller.pause();
      }

      // pause when out of bounds
      if (childValue.playState.value != PlayState.paused &&
          !childTargetInBounds) {
        debugPrint('child #$index paused (out of bounds)');
        await child.controller.pause();
      }
    }
  }

  /// Synchronize state of the group and all it's children.
  ///
  /// This is usually called automatically, but can be called manually if
  /// necessary.
  Future<void> sync() async {
    if (value.playState.value == PlayState.uninitialized ||
        _disposed ||
        children.isEmpty) return;

    // TODO add debouncing logic/redundancy check

    await _syncMutex.protect(() async {
      debugPrint("SYNC iteration:");
      children.forEachIndexed((child, i) {
        debugPrint("child #$i: ${child.controller.value.toStringCompact()}");
      });

      // TODO initialize uninitialized children?

      await _syncFromChildren();
      await _syncToChildren();

      debugPrint("SYNC done:");
      debugPrint("group: ${value.toStringCompact()}");
      children.forEachIndexed((child, i) {
        debugPrint("child #$i: ${child.controller.value.toStringCompact()}");
      });
    });
  }
}
