import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:logger/logger.dart';
import 'package:mutex/mutex.dart';

import 'duration_range.dart';
import 'generic_player_state.dart';
import 'generic_player_controller.dart';

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
  SyncedPlayerGroupController({
    required this.children,
    this.marginOfError = const Duration(milliseconds: 200),
    this.syncPeriod = const Duration(milliseconds: 200),
  });

  // TODO make immutable from outside the class, or allow adding/removing children properly
  final List<SyncedController> children;
  final Duration marginOfError;
  final Duration? syncPeriod;

  Timer? _syncTimer;

  final Mutex _syncMutex = Mutex();
  late Future<void> _syncFuture;
  bool _pendingSync = false;
  var _syncCount = 0;

  bool _disposed = false;

  final _memoryOutput = MemoryOutput(bufferSize: 200);
  late final _logger = Logger(
    output: _memoryOutput,
    printer: PrettyPrinter(
      printTime: true,
      methodCount: 0,
    ),
  );

  List<OutputEvent> get logOutput => _memoryOutput.buffer.toUnmodifiable();

  @override
  Future<void> initialize() async {
    if (value.playState.value != PlayState.uninitialized || _disposed) return;

    addListener(() {
      _logger.d("value changed: ${value.toStringCompact()}");
    });

    // initialize children
    for (final child in children) {
      if (child.controller.value.playState.value == PlayState.uninitialized) {
        await child.controller.initialize();
      }
    }

    value = value.copyWith(playState: PlayState.paused);

    // initial sync
    await sync();
  }

  @override
  Future<void> dispose() async {
    if (value.playState.value == PlayState.uninitialized || _disposed) return;

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
      position: value.atEnd
          ? value.positionRange.value.start // restart if ended
          : value.position.value, // keep value, refresh timestamp
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

  Future<GenericPlayerState> _syncFromChildren(
    GenericPlayerState groupState,
    Map<SyncedController, GenericPlayerState> childrenValues,
  ) async {
    var combinedState = groupState;

    final Duration? earliestStart = childrenValues.entries
        .map(
            (entry) => entry.value.positionRange.value.start + entry.key.offset)
        .min();
    final latestEnd = childrenValues.entries
        .map((entry) =>
            entry.value.positionRange.value.endInclusive + entry.key.offset)
        .max();

    final totalRange = DurationRange(
      earliestStart ?? Duration.zero,
      latestEnd ?? Duration.zero,
    );

    // positionRange
    if (groupState.positionRange.value != totalRange) {
      _logger.d('positionRange changed to $totalRange');
      combinedState = combinedState.copyWith(positionRange: totalRange);
    }

    // position
    final newestPositionedChildren = childrenValues.entries
        .sortedByDescending((entry) => entry.value.position.timestamp);
    final newestPosition = newestPositionedChildren
        .filterNot((entry) =>
            entry.value.atEnd || entry.value.atStart) // estimated end?
        .firstOrNullWhere((entry) => entry.value.position.timestamp
            .isAfter(groupState.position.timestamp))
        ?.key
        .estimatedNormalizedPosition;
    if (newestPosition != null &&
        !groupState.estimatedPosition
            .inRange(newestPosition.addMargin(marginOfError))) {
      _logger.d('position changed to $newestPosition');
      combinedState = combinedState.copyWith(position: newestPosition);
    }

    // playState
    final anyBuffering = childrenValues.values.any((childValue) =>
        childValue.playState.value == PlayState.playingBuffering);
    final sortedByPlayState = childrenValues.entries
        // ignore invalid states
        .filterNot((entry) => !entry.value.positionRange.value
            .contains(groupState.estimatedPosition - entry.key.offset))
        .sortedByDescending((entry) => entry.value.playState.timestamp);

    //  playing -> buffering
    if (groupState.playState.value == PlayState.playing && anyBuffering) {
      _logger.d('playState changed: playing -> buffering');
      combinedState = combinedState.copyWith(
        playState: PlayState.playingBuffering,
        position: groupState.position.value, // refresh timestamp
      );
    }
    //  buffering -> playing
    else if (groupState.playState.value == PlayState.playingBuffering &&
        !anyBuffering) {
      _logger.d('playState changed: buffering -> playing');
      combinedState = combinedState.copyWith(
        playState: PlayState.playing,
        position: groupState.estimatedPosition, // refresh timestamp
      );
    }

    final playingIsNewest =
        sortedByPlayState.firstOrNull?.value.playState.value ==
                PlayState.playing &&
            sortedByPlayState.firstOrNull?.value.playState.timestamp
                    .isAfter(groupState.playState.timestamp) ==
                true;
    final pausedIsNewest =
        sortedByPlayState.firstOrNull?.value.playState.value ==
                PlayState.paused &&
            sortedByPlayState.firstOrNull?.value.playState.timestamp
                    .isAfter(groupState.playState.timestamp) ==
                true;
    //  paused -> playing
    if (groupState.playState.value == PlayState.paused && playingIsNewest) {
      _logger.d('playState changed: paused -> playing');
      combinedState = combinedState.copyWith(
        playState: PlayState.playing,
        position: groupState.estimatedPosition, // refresh timestamp
      );
    }
    //  playing -> paused
    else if (groupState.playState.value == PlayState.playing &&
        pausedIsNewest) {
      _logger.d('playState changed: playing -> paused');
      combinedState = combinedState.copyWith(
        playState: PlayState.paused,
        position: groupState.estimatedPosition, // refresh timestamp
      );
    }

    //  buffering -> paused
    //   does not happen automatically from children

    // TODO speed

    return combinedState;
  }

  Future<void> _syncToChildren(
    GenericPlayerState groupState,
    Map<SyncedController, GenericPlayerState> childrenValues,
  ) async {
    // TODO check if any child is disposed?
    // TODO initialize uninitialized children?

    for (final (index, childEntry) in childrenValues.entries.indexed) {
      final childValue = childEntry.value;

      final childPosition = childValue.estimatedPosition;
      final childTargetPosition =
          groupState.estimatedPosition - childEntry.key.offset;
      final childTargetPositionRange =
          childTargetPosition.addMargin(marginOfError);

      final childTargetInBounds =
          childTargetPosition.inRange(childValue.positionRange.value);

      // setPosition in range
      if (childPosition.inRange(childTargetPositionRange) == false &&
          childTargetInBounds) {
        _logger.d('child #$index position set to $childTargetPosition');
        await childEntry.key.controller.setPosition(childTargetPosition);
      }
      // setPosition clamp to end
      else if (!childValue.atEnd &&
          childTargetPosition > childValue.positionRange.value.endInclusive) {
        _logger.d(
            'child #$index position clamped to ${childValue.positionRange.value.endInclusive}');
        await childEntry.key.controller
            .setPosition(childValue.positionRange.value.endInclusive);
      }
      // setPosition clamp to start
      else if (!childValue.atStart &&
          childTargetPosition < childValue.positionRange.value.start) {
        _logger.d(
            'child #$index position clamped to ${childValue.positionRange.value.start}');
        await childEntry.key.controller
            .setPosition(childValue.positionRange.value.start);
      }

      // play
      if (groupState.playState.value == PlayState.playing &&
          childValue.playState.value == PlayState.paused &&
          childTargetInBounds) {
        _logger.d('child #$index played');
        await childEntry.key.controller.play();
      }

      // pause when paused/buffering
      if ((groupState.playState.value == PlayState.paused ||
              groupState.playState.value == PlayState.playingBuffering) &&
          childValue.playState.value == PlayState.playing) {
        _logger.d('child #$index paused');
        await childEntry.key.controller.pause();
      }

      // pause when out of bounds
      if (childValue.playState.value != PlayState.paused &&
          !childTargetInBounds) {
        _logger.d('child #$index paused (out of bounds)');
        await childEntry.key.controller.pause();
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

    _pendingSync = true;

    // redundancy check
    if (_syncMutex.isLocked) {
      _logger.d('(SYNC called, but ignored for ${_syncFuture.hashCode})');
      await _syncFuture;
      return;
    }

    final syncNum = _syncCount;
    _syncCount += 1;

    _syncFuture = _syncMutex.protect(() async {
      _syncTimer?.cancel();
      _logger.d("SYNC START #$syncNum (${_syncFuture.hashCode})");
      var iteration = 0;
      while (_pendingSync) {
        _pendingSync = false;
        _logger.d(buildString((sb) {
          sb.write("SYNC iteration #$iteration:\n");
          sb.write(children
              .map((e) => e.controller.value.toStringCompact())
              .mapIndexed((index, str) => "child #$index: $str")
              .join('\n'));
        }));

        // caching to prevent race conditions
        final groupValue = value;
        final childrenValues = {
          for (final child in children) child: child.controller.value
        };

        final newGroupValue =
            await _syncFromChildren(groupValue, childrenValues);
        await _syncToChildren(newGroupValue, childrenValues);
        value = newGroupValue;

        _logger.d(buildString((sb) {
          sb.write("SYNC done:\n");
          sb.write("group: ${value.toStringCompact()}\n");
          sb.write(children
              .map((e) => e.controller.value.toStringCompact())
              .mapIndexed((index, str) => "child #$index: $str")
              .join('\n'));
        }));

        // needed because DateTime.now() resolution is too imprecise,
        // sync might get confused on what value is actually latest.
        // the delay makes sure the time is different between each sync attempt.
        // TODO replace DateTime with different library?
        sleep(const Duration(milliseconds: 2));

        iteration += 1;
      }
      _logger.d("SYNC END #$syncNum (${_syncFuture.hashCode})");

      final syncPeriod = this.syncPeriod;
      if (syncPeriod != null) {
        _syncTimer = Timer(syncPeriod, sync);
      }
    });
    await _syncFuture;
  }
}
