import 'dart:async';

import 'package:flutter/foundation.dart';

import 'generic_player_state.dart';

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
// TODO maybe split the notifying to have a notifier for each field
abstract class GenericPlayerController
    extends ValueNotifier<GenericPlayerState> {
  GenericPlayerController({
    this.obstructionBehavior = ObstructionBehavior.none,
    this.label,
  }) : super(GenericPlayerState.uninitialized());

  /// An optional label for this controller
  final String? label;

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
  // TODO maybe replace with Future<GenericPlayerState>
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

// TODO add isInitialized and isDisposed?
}
