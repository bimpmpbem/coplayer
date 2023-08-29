import 'package:coplayer/snapshot.dart';
import 'package:coplayer/generic_player_controller.dart';
import 'package:flutter/foundation.dart';

import 'duration_range.dart';

enum PlayState {
  /// Playback is playing and will progress automatically over time.
  ///
  /// When in this state, playback is progressing linearly and can be estimated
  /// using last known position.
  playing('▶', 'Playing'),

  /// Playback is temporarily paused to buffer content.
  /// When buffering completes, playback will resume automatically.
  playingBuffering('↺', 'Buffering'),

  // /// Playback is temporarily paused due to position reaching the start or end
  // /// of the content.
  // /// When position is changed to a valid value,
  // /// playback will resume automatically.
  // playingClamped('X'),

  /// The content is paused until resumed manually.
  paused('⏸', 'Paused'),

  // pausedUnplayable?

  // looping?

  /// Stopped due to error in playback.
  error('⚠', 'Error'),

  /// Content not loaded yet.
  uninitialized('X', 'Unloaded');

  // disposed?

  const PlayState(this.symbol, this.shortText);

  final String symbol;
  final String shortText;
}

/// A state of a [GenericPlayerController].
/// Contains start/end/current position, buffering status, error status, etc.
/// as a [Snapshot] with the time of last change.
// Copied from video_player, and modified to be more generic
// (w/o audio, captions, etc.)
class GenericPlayerState {
  const GenericPlayerState({
    required this.positionRange,
    required this.position,
    required this.playState,
    required this.isLooping,
    required this.playbackSpeed,
    required this.errorDescription,
  });

  /// Constructs with the given values.
  /// Only [startPosition] and [endPosition] is required.
  /// The rest will initialize with default values when unset.
  GenericPlayerState.now({
    required DurationRange positionRange,
    Duration position = Duration.zero,
    PlayState playState = PlayState.uninitialized,
    bool isLooping = false,
    double playbackSpeed = 1.0,
    String? errorDescription,
  })
      : positionRange = Snapshot.now(positionRange),
        position = Snapshot.now(position),
        playState = Snapshot.now(playState),
        isLooping = Snapshot.now(isLooping),
        playbackSpeed = Snapshot.now(playbackSpeed),
        errorDescription =
            errorDescription == null ? null : Snapshot.now(errorDescription);

  /// Returns an instance for content that hasn't been loaded.
  GenericPlayerState.uninitialized()
      : this.now(
            positionRange: Duration.zero.rangeTo(Duration.zero),
            playState: PlayState.uninitialized);

  /// Returns an instance with the given [errorDescription].
  GenericPlayerState.erroneous(String errorDescription)
      : this.now(
      positionRange: Duration.zero.rangeTo(Duration.zero),
            playState: PlayState.uninitialized,
            errorDescription: errorDescription);

  /// This constant is just to indicate that parameter is not passed to [copyWith]
  /// workaround for this issue https://github.com/dart-lang/language/issues/2009
  static const String _defaultErrorDescription = 'defaultErrorDescription';

  /// The range of possible points in time of the content.
  ///
  /// The range is zero if the content hasn't been initialized.
  ///
  /// Note that the [positionRange] is not necessarily constant and
  /// might change during the life of the content (for example, livestreams)
  final Snapshot<DurationRange> positionRange;

  /// The current duration of the content.
  ///
  /// The [duration] is [Duration.zero]
  /// if the content hasn't been initialized.
  ///
  /// Note that the [duration] is not necessarily constant and
  /// might change during the life of the content (for example, livestreams)
  Duration get duration =>
      positionRange.value.endInclusive - positionRange.value.start;

  /// True if the current [position] is at [startPosition]
  bool get atStart => position.value == positionRange.value.start;

  /// True if the current [position] is at [endPosition]
  bool get atEnd => position.value == positionRange.value.endInclusive;

  /// The current playback position.
  ///
  /// Always between [startPosition] and [endPosition].
  final Snapshot<Duration> position;

  Duration get estimatedPosition {
    if (playState.value != PlayState.playing) return position.value;

    final timePassed = DateTime.now().difference(position.timestamp);

    return (position.value + timePassed * playbackSpeed.value)
        .clampToRange(positionRange.value);
  }

  /// Current state of playback
  final Snapshot<PlayState> playState;

  /// True if the content is looping.
  // TODO remove?
  final Snapshot<bool> isLooping;

  /// The current speed of the playback,
  /// where 0 means no progress, and 1 means normal/default playback.
  ///
  /// Different values support (<0, 0->1, >1) depend on implementation.
  final Snapshot<double> playbackSpeed;

  /// A description of the error if present.
  ///
  /// If [hasError] is false this is `null`.
  final Snapshot<String>? errorDescription;

  /// Indicates whether or not the content is in an error state. If this is true
  /// [errorDescription] should have information about the problem.
  bool get hasError => errorDescription != null;

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWith].
  // TODO split to copyWith and copyWithValues?
  GenericPlayerState copyWith({
    DurationRange? positionRange,
    Duration? position,
    PlayState? playState,
    bool? isLooping,
    double? playbackSpeed,
    String? errorDescription = _defaultErrorDescription,
  }) {
    return GenericPlayerState(
      positionRange: positionRange?.snapshot() ?? this.positionRange,
      position: position?.snapshot() ?? this.position,
      playState: playState?.snapshot() ?? this.playState,
      isLooping: isLooping?.snapshot() ?? this.isLooping,
      playbackSpeed: playbackSpeed?.snapshot() ?? this.playbackSpeed,
      errorDescription: errorDescription != _defaultErrorDescription
          ? errorDescription?.snapshot()
          : this.errorDescription,
    );
  }

  GenericPlayerState copyWithOffset(Duration offset) {
    return GenericPlayerState(
      positionRange:
          positionRange.copyWith(value: positionRange.value.withOffset(offset)),
      position: position.copyWith(value: position.value + offset),
      playState: playState,
      isLooping: isLooping,
      playbackSpeed: playbackSpeed,
      errorDescription: errorDescription,
    );
  }

  // TODO add copyWithPosition?

  @override
  String toString() {
    return '${objectRuntimeType(this, 'VideoPlayerValue')}('
        'positionRange: $positionRange, '
        'position: $position, '
        'playState: $playState, '
        'isLooping: $isLooping, '
        'playbackSpeed: $playbackSpeed, '
        'errorDescription: $errorDescription)';
  }

  String toStringCompact() {
    return "${playState.value.symbol} |"
        " x${playbackSpeed.value.toStringAsPrecision(3)} |"
        " ${positionRange.value.start}\\${position.value}/${positionRange.value.endInclusive} |"
        " Error: ${errorDescription ?? 'None'}";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenericPlayerState &&
          runtimeType == other.runtimeType &&
          positionRange == other.positionRange &&
          position == other.position &&
          playState == other.playState &&
          isLooping == other.isLooping &&
          playbackSpeed == other.playbackSpeed &&
          errorDescription == other.errorDescription;

  @override
  int get hashCode => Object.hash(
    positionRange,
        position,
        playState,
        isLooping,
        playbackSpeed,
        errorDescription,
      );
}
