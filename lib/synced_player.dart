import 'dart:math';

import 'package:flutter/foundation.dart';

/// The duration, current position, buffering state, error state and settings
/// of a [GenericPlayerController].
// Copied from video_player, and modified to be more generic
// (w/o audio, captions, etc.)
@immutable
class GenericPlayerValue {
  /// Constructs with the given values. Only [duration] is required. The
  /// rest will initialize with default values when unset.
  const GenericPlayerValue({
    required this.duration,
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
      : this(duration: Duration.zero, isInitialized: false);

  /// Returns an instance with the given [errorDescription].
  const GenericPlayerValue.erroneous(String errorDescription)
      : this(
            duration: Duration.zero,
            isInitialized: false,
            errorDescription: errorDescription);

  /// This constant is just to indicate that parameter is not passed to [copyWith]
  /// workaround for this issue https://github.com/dart-lang/language/issues/2009
  static const String _defaultErrorDescription = 'defaultErrorDescription';

  /// The current total duration of the content.
  ///
  /// The duration is [Duration.zero] if the content hasn't been initialized.
  ///
  /// Note that the duration is not necessarily constant and
  /// might change during the life of the content (for example, livestreams)
  final Duration duration;

  /// The current playback position.
  final Duration position;

  /// True if the content is playing. False if it's paused.
  final bool isPlaying;

  /// True if the content is looping.
  final bool isLooping;

  /// True if the content is currently buffering.
  final bool isBuffering;

  /// The current speed of the playback.
  final double playbackSpeed;

  /// A description of the error if present.
  ///
  /// If [hasError] is false this is `null`.
  final String? errorDescription;

  /// Indicates whether or not the content has been loaded and is ready to play.
  final bool isInitialized;

  /// Indicates whether or not the content is in an error state. If this is true
  /// [errorDescription] should have information about the problem.
  bool get hasError => errorDescription != null;

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWith].
  GenericPlayerValue copyWith({
    Duration? duration,
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
      duration: duration ?? this.duration,
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
        'duration: $duration, '
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
          duration == other.duration &&
          position == other.position &&
          isPlaying == other.isPlaying &&
          isLooping == other.isLooping &&
          isBuffering == other.isBuffering &&
          playbackSpeed == other.playbackSpeed &&
          errorDescription == other.errorDescription &&
          isInitialized == other.isInitialized;

  @override
  int get hashCode => Object.hash(
        duration,
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
    Duration initialDuration = Duration.zero,
  }) : super(GenericPlayerValue(duration: initialDuration));

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

  /// Starts playing the content.
  ///
  /// If the content is at the end, this method starts playing from the beginning.
  Future<void> play();

  /// Pauses the content.
  Future<void> pause();

  /// Gets the content's position as a [Duration] from the start.
  ///
  /// Will return null if not initialized.
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
  /// [speed] indicates a speed value with different implementations accepting
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
/// The total duration will be the largest duration + offset of the controllers.
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
        microseconds: max(mainController.value.duration.inMicroseconds,
            (secondaryController.value.duration + offset).inMicroseconds));

    final Duration minPosition =
        Duration(microseconds: min(0, offset.inMicroseconds));

    final Duration mainPosition = position;
    final Duration secondaryPosition = position - offset;

    if (position >= maxPosition) {
      // pause
      await pause();

      // clamp
      await Future.wait([
        _setControllerPosition(
          mainController,
          mainController.value.duration,
        ),
        _setControllerPosition(
          secondaryController,
          secondaryController.value.duration,
        ),
      ]);

      value = value.copyWith(position: maxPosition);

      // TODO looping?
    } else if (position <= minPosition) {
      await Future.wait([
        // clamp
        _setControllerPosition(mainController, Duration.zero),
        _setControllerPosition(secondaryController, Duration.zero),
      ]);

      value = value.copyWith(position: minPosition);
    } else {
      await Future.wait([
        _setControllerPosition(mainController, mainPosition),
        _setControllerPosition(secondaryController, secondaryPosition),
      ]);

      value = value.copyWith(position: position);
    }
  }

  Future<void> _setControllerPosition(
      GenericPlayerController controller, Duration position) {
    if (position > controller.value.duration) {
      return controller
          .pause()
          .then((_) => controller.setPosition(controller.value.duration));
    } else if (position < Duration.zero) {
      return controller
          .pause()
          .then((_) => controller.setPosition(Duration.zero));
    } else {
      return controller.setPosition(position).then((_) {
        if (value.isPlaying) {
          controller.play();
        } else {
          controller.pause();
        }
      });
    }
  }

  @override
  Future<void> play() async {
    if (!value.isInitialized) return;

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
  Future<Duration?> get position => throw UnimplementedError();

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
