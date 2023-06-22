import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';

/// The start/end/current position, buffering state, error state and settings
/// of a [GenericPlayerController].
// Copied from video_player, and modified to be more generic
// (w/o audio, captions, etc.)
@immutable
class GenericPlayerValue {
  /// Constructs with the given values.
  /// Only [startPosition] and [endPosition] is required.
  /// The rest will initialize with default values when unset.
  const GenericPlayerValue({
    this.startPosition = Duration.zero,
    required this.endPosition,
    this.position = Duration.zero,
    this.isInitialized = false,
    this.isPlaying = false,
    this.isLooping = false,
    this.isBuffering = false,
    this.playbackSpeed = 1.0,
    this.errorDescription,
  });

  /// Returns an instance for content that hasn't been loaded.
  const GenericPlayerValue.uninitialized()
      : this(
            startPosition: Duration.zero,
            endPosition: Duration.zero,
            isInitialized: false);

  /// Returns an instance with the given [errorDescription].
  const GenericPlayerValue.erroneous(String errorDescription)
      : this(
            startPosition: Duration.zero,
            endPosition: Duration.zero,
            isInitialized: false,
            errorDescription: errorDescription);

  /// This constant is just to indicate that parameter is not passed to [copyWith]
  /// workaround for this issue https://github.com/dart-lang/language/issues/2009
  static const String _defaultErrorDescription = 'defaultErrorDescription';

  /// The current lowest point in time of the content.
  ///
  /// The [startPosition] is [Duration.zero]
  /// if the content hasn't been initialized.
  ///
  /// Note that the [startPosition] is not necessarily constant and
  /// might change during the life of the content (for example, livestreams)
  // TODO rename to firstPosition?
  final Duration startPosition;

  /// The current highest point in time of the content.
  ///
  /// The [endPosition] is [Duration.zero]
  /// if the content hasn't been initialized.
  ///
  /// Note that the [endPosition] is not necessarily constant and
  /// might change during the life of the content (for example, livestreams)
  // TODO rename to lastPosition?
  final Duration endPosition;

  /// The current duration of the content.
  ///
  /// The [duration] is [Duration.zero]
  /// if the content hasn't been initialized.
  ///
  /// Note that the [duration] is not necessarily constant and
  /// might change during the life of the content (for example, livestreams)
  Duration get duration => endPosition - startPosition;

  /// True if the current [position] is at [startPosition]
  bool get atStart => position == startPosition;

  /// True if the current [position] is at [endPosition]
  bool get atEnd => position == endPosition;

  /// The current playback position.
  ///
  /// Always between [startPosition] and [endPosition].
  final Duration position;

  /// True if the content is playing, and [position] might change over time.
  /// Does not imply anything about [playbackSpeed], or [isBuffering] state.
  ///
  /// False if it's paused, and [position] will not update unless
  /// manually changed.
  final bool isPlaying;

  /// True if the content is looping.
  // TODO remove?
  final bool isLooping;

  /// True if the content is currently buffering.
  ///
  /// Does not necessarily mean content is paused.
  final bool isBuffering;

  /// The current speed of the playback,
  /// where 0 means no progress, and 1 means normal/default playback.
  ///
  /// Different values support (<0, 0->1, >1) depend on implementation.
  final double playbackSpeed;

  /// A description of the error if present.
  ///
  /// If [hasError] is false this is `null`.
  final String? errorDescription;

  /// Indicates whether or not the content has been loaded and is ready to play.
  // TODO remove and just use nullable ValueNotifier<GenericPlayerValue?> for uninitialized
  final bool isInitialized;

  /// Indicates whether or not the content is in an error state. If this is true
  /// [errorDescription] should have information about the problem.
  bool get hasError => errorDescription != null;

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWith].
  GenericPlayerValue copyWith({
    Duration? startPosition,
    Duration? endPosition,
    Duration? syncOffset,
    Duration? position,
    bool? isInitialized,
    bool? isPlaying,
    bool? isLooping,
    bool? isBuffering,
    double? playbackSpeed,
    int? rotationCorrection,
    String? errorDescription = _defaultErrorDescription,
  }) {
    return GenericPlayerValue(
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      position: position ?? this.position,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isLooping: isLooping ?? this.isLooping,
      isBuffering: isBuffering ?? this.isBuffering,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorDescription: errorDescription != _defaultErrorDescription
          ? errorDescription
          : this.errorDescription,
    );
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'VideoPlayerValue')}('
        'startPosition: $startPosition, '
        'endPosition: $endPosition, '
        'position: $position, '
        'isInitialized: $isInitialized, '
        'isPlaying: $isPlaying, '
        'isLooping: $isLooping, '
        'isBuffering: $isBuffering, '
        'playbackSpeed: $playbackSpeed, '
        'errorDescription: $errorDescription)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenericPlayerValue &&
          runtimeType == other.runtimeType &&
          startPosition == other.startPosition &&
          endPosition == other.endPosition &&
          position == other.position &&
          isPlaying == other.isPlaying &&
          isLooping == other.isLooping &&
          isBuffering == other.isBuffering &&
          playbackSpeed == other.playbackSpeed &&
          errorDescription == other.errorDescription &&
          isInitialized == other.isInitialized;

  @override
  int get hashCode => Object.hash(
        startPosition,
        endPosition,
        position,
        isPlaying,
        isLooping,
        isBuffering,
        playbackSpeed,
        errorDescription,
        isInitialized,
      );
}

/// Types of behavior a [GenericPlayerController] can choose when encountering
/// an obstruction.
enum ObstructionBehavior {
  /// Keep playing normally.
  none,

  /// Attempt to reduce resource usage as much as possible.
  // TODO maybe remove this
  optimize,

  /// Pause playback until obstruction is removed.
  pauseUntilRemoved,

  /// Pause playback until manual play request.
  pauseUntilPlay,
}

/// An interface for player controllers that allow common basic controls.
abstract class GenericPlayerController
    extends ValueNotifier<GenericPlayerValue> {
  GenericPlayerController({
    this.obstructionBehavior = ObstructionBehavior.none,
  }) : super(const GenericPlayerValue.uninitialized());

  /// Specifies how playback should change when there is some interruption
  /// to the user.
  ///
  /// For example: if a video is hidden because app is in the background,
  /// or if audio is being interrupted by some music
  // TODO maybe this should not be part of the interface
  final ObstructionBehavior obstructionBehavior;

  /// Attempts to open the relevant sources and load metadata about the content.
  Future<void> initialize();

  @override
  Future<void> dispose() async => super.dispose();

  /// Attempts to play the content.
  ///
  /// Might be unsuccessful if an error occurred,
  /// or if already at end of content.
  Future<void> play();

  /// Pauses the content.
  Future<void> pause();

  /// Gets the content's position as a [Duration] from the start.
  ///
  /// Will return null if not initialized.
  // TODO just use value.position?
  Future<Duration?> get position;

  /// Sets the content's current [position].
  /// The next time the content is played
  /// it will resume from the given [position].
  ///
  /// If [position] is outside of the content's valid range it will
  /// be automatically and silently clamped.
  Future<void> setPosition(Duration position);

  /// Sets the playback speed.
  ///
  /// [speed] indicates a speed value, with different implementations accepting
  /// different ranges for speed values. The [speed] must be greater than 0.
  // TODO allow negative speed?
  Future<void> setPlaybackSpeed(double speed);
}

/// A pair of [GenericPlayerController]s,
/// which are kept in sync with each other.
///
/// All the controllers' play/pause/speed/position states will stay in sync,
/// while applying their respective offsets.
///
/// The pair will end playback once the last controller has ended playback.
///
/// The pair's startPosition will be the smallest of the controller's
/// startPosition, and the endPosition will be the largest endPosition.
// TODO extend dartx Pair?
class SyncedPlayerControllerPair extends GenericPlayerController {
  SyncedPlayerControllerPair({
    required this.mainController,
    required this.secondaryController,
    this.offset = Duration.zero,
    this.syncPeriod = const Duration(milliseconds: 500),
    this.marginOfError = const Duration(milliseconds: 500),
  });

  /// A controller to be considered the 'main' reference.
  /// The [secondaryController] will be synced relative to this.
  // TODO maybe accept ValueNotifier<GenericPlayerValue> instead
  final GenericPlayerController mainController;

  /// A controller to be considered the 'secondary' reference.
  /// This will be synced relative to the [mainController].
  final GenericPlayerController secondaryController;

  /// A duration specifying the offset between the [mainController] and the
  /// [secondaryController].
  Duration offset;

  /// A duration specifying often should the controllers' position checked and
  /// synced if needed.
  final Duration syncPeriod;

  /// A duration specifying how large the difference between the
  /// [mainController] and [secondaryController] can be before being considered
  /// out of sync.
  final Duration marginOfError;

  @override
  Future<void> initialize() async {
    if (mainController.value.isInitialized == false) {
      await mainController.initialize();
    }
    if (secondaryController.value.isInitialized == false) {
      await secondaryController.initialize();
    }

    value = value.copyWith(isInitialized: true);

    // TODO register listeners
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    throw UnimplementedError();
    super.dispose();
  }

  @override
  Future<void> setPosition(Duration position) async {
    if (!value.isInitialized) return;

    final Duration maxPosition = Duration(
        microseconds: max(mainController.value.endPosition.inMicroseconds,
            (secondaryController.value.endPosition + offset).inMicroseconds));

    final Duration minPosition = Duration(
        microseconds: min(mainController.value.startPosition.inMicroseconds,
            (secondaryController.value.startPosition + offset).inMicroseconds));

    final clampedPosition = position.clamp(min: minPosition, max: maxPosition);

    final Duration mainPosition = clampedPosition;
    final Duration secondaryPosition = clampedPosition - offset;

    // set position (and possibly clamp/pause)
    await Future.wait([
      mainController.setPosition(mainPosition),
      secondaryController.setPosition(secondaryPosition),
    ]);

    // update
    value = value.copyWith(position: clampedPosition);
  }

  @override
  Future<void> play() async {
    if (!value.isInitialized) return;

    // sync
    if (mainController.value.isPlaying) {
      // sync to main if playing
      final position = (await mainController.position)!;
      await secondaryController.setPosition(position - offset);
      value = value.copyWith(position: position);
    } else if (secondaryController.value.isPlaying) {
      // sync to secondary if playing
      final position = (await secondaryController.position)!;
      await mainController.setPosition(position + offset);
      value = value.copyWith(position: position);
    } else {
      // sync to pair if not playing
      final position = (await this.position)!;
      await Future.wait([
        mainController.setPosition(position),
        secondaryController.setPosition(position - offset),
      ]);
    }

    // try playing
    await Future.wait([
      mainController.play(),
      secondaryController.play(),
    ]);

    value = value.copyWith(isPlaying: true);
  }

  @override
  Future<void> pause() async {
    if (!value.isInitialized) return;

    await Future.wait([
      mainController.pause(),
      secondaryController.pause(),
    ]);

    value = value.copyWith(isPlaying: false);
  }

  @override
  // TODO: implement position
  Future<Duration?> get position async => value.position;

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    // TODO: implement setPlaybackSpeed
    throw UnimplementedError();
  }

  /// Synchronize immediately, instead of waiting for [syncPeriod].
  Future<void> forceSync({bool ignoreMarginOfError = false}) async {
    // TODO: implement forceSync
    throw UnimplementedError();
  }

// TODO volume controls?
}
