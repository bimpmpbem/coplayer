import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dartx/dartx.dart';

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

// A pair of [GenericPlayerController]s,
// which are kept in sync with each other.
//
// All the controllers' play/pause/speed/position states will stay in sync,
// while applying their respective offsets.
//
// The pair will end playback once the last controller has ended playback.
//
// The pair's startPosition will be the smallest of the controller's
// startPosition, and the endPosition will be the largest endPosition.

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

  Completer<void>? _syncCompleter;
  bool _pendingSync = false;
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
    final targetPosition = await position;
    if (targetPosition == null) return;

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

    // playState
    final anyBuffering = children.any((child) =>
        child.controller.value.playState.value == PlayState.playingBuffering);
    final sortedByPlayState = children
        // ignore invalid states
        .filterNot((child) => !child.controller.value.positionRange.value
            .contains(targetPosition - child.offset))
        .sortedByDescending(
            (child) => child.controller.value.playState.timestamp);

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

    //  buffering -> paused
    //   does not happen automatically from children

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

    // TODO speed
  }

  Future<void> _syncToChildren() async {
    final targetPosition = await position;
    if (targetPosition == null) return;

    // TODO check if any child is disposed?

    // children from parent
    for (final (index, child) in children.indexed) {
      final childPosition = child.controller.value.estimatedPosition;
      final childTargetPosition = targetPosition - child.offset;
      final childTargetPositionRange =
          childTargetPosition.addMargin(marginOfError);

      final childTargetInBounds = childTargetPosition
          .inRange(child.controller.value.positionRange.value);

      // setPosition in range
      if (childPosition.inRange(childTargetPositionRange) == false &&
          childTargetInBounds) {
        debugPrint('child #$index position set to $childTargetPosition');
        await child.controller.setPosition(childTargetPosition);
      }
      // setPosition clamp to end
      else if (!child.controller.value.atEnd &&
          childTargetPosition >
              child.controller.value.positionRange.value.endInclusive) {
        debugPrint(
            'child #$index position clamped to ${child.controller.value.positionRange.value.endInclusive}');
        await child.controller.setPosition(
            child.controller.value.positionRange.value.endInclusive);
      }
      // setPosition clamp to start
      else if (!child.controller.value.atStart &&
          childTargetPosition <
              child.controller.value.positionRange.value.start) {
        debugPrint(
            'child #$index position clamped to ${child.controller.value.positionRange.value.start}');
        await child.controller
            .setPosition(child.controller.value.positionRange.value.start);
      }

      // play
      if (value.playState.value == PlayState.playing &&
          child.controller.value.playState.value == PlayState.paused &&
          childTargetInBounds) {
        debugPrint('child #$index played');
        await child.controller.play();
      }

      // pause when paused/buffering
      if ((value.playState.value == PlayState.paused ||
              value.playState.value == PlayState.playingBuffering) &&
          child.controller.value.playState.value == PlayState.playing) {
        debugPrint('child #$index paused');
        await child.controller.pause();
      }

      // pause when out of bounds
      if (child.controller.value.playState.value != PlayState.paused &&
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

    // make sure this function only runs sequentially in a single thread
    _pendingSync = true;
    final existingCompleter = _syncCompleter;
    if (existingCompleter != null) {
      // already syncing in another thread, let it handle this
      debugPrint("(SYNC called but ignored)");
      return existingCompleter.future;
    }

    debugPrint("SYNC called");
    final syncCompleter = Completer();
    _syncCompleter = syncCompleter;

    while (_pendingSync) {
      debugPrint("SYNC iteration:");
      children.forEachIndexed((child, i) {
        debugPrint("child #$i: ${child.controller.value.toStringCompact()}");
      });
      _pendingSync = false;

      // TODO initialize uninitialized children?

      await _syncFromChildren();
      await _syncToChildren();
    }

    debugPrint("SYNC done.");
    syncCompleter.complete();
    _syncCompleter = null;
    return syncCompleter.future;
  }
}
