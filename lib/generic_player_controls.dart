import 'package:coplayer/duration_extensions.dart';
import 'package:coplayer/generic_player_state.dart';
import 'package:flutter/material.dart';

class GenericPlayerControls extends StatefulWidget {
  const GenericPlayerControls({
    super.key,
    required this.state,
    this.onPositionChanged,
    this.onPlay,
    this.onPause,
  });

  final GenericPlayerState state;
  final void Function(Duration newPosition)? onPositionChanged;
  final void Function()? onPlay;
  final void Function()? onPause;

  @override
  State<GenericPlayerControls> createState() => _GenericPlayerControlsState();
}

class _GenericPlayerControlsState extends State<GenericPlayerControls> {
  double? _changingValue;

  @override
  Widget build(BuildContext context) {
    final position = widget.state.position.value;
    final start = widget.state.positionRange.value.start;
    final end = widget.state.positionRange.value.endInclusive;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(start.toStringCompact()),
            Slider(
              value: _changingValue ?? position.inMicroseconds.toDouble(),
              min: start.inMicroseconds.toDouble(),
              max: end.inMicroseconds.toDouble(),
              onChangeStart: (value) {
                setState(() {
                  _changingValue = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  _changingValue = value;
                });
              },
              onChangeEnd: (value) {
                _changingValue = null;
                widget.onPositionChanged
                    ?.call(Duration(microseconds: value.toInt()));
              },
            ),
            Text(end.toStringCompact()),
          ],
        ),
        Row(
          children: [
            widget.state.playState.value == PlayState.paused
                ? const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.play_arrow),
                  )
                : const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.pause),
                  ),
            const IconButton(onPressed: null, icon: Icon(Icons.volume_up)),
            Text(position.toStringCompact()),
          ],
        ),
      ],
    );
  }
}
