import 'dart:math';

import 'package:dartx/dartx.dart';

class DurationRange extends Range<Duration> {
  static const zero = DurationRange(Duration.zero, Duration.zero);

  const DurationRange(this.start, this.endInclusive);

  @override
  final Duration start;

  @override
  final Duration endInclusive;

  DurationRange expandToInclude(DurationRange otherRange) {
    return DurationRange(
        Duration(
            microseconds:
                min(start.inMicroseconds, otherRange.start.inMicroseconds)),
        Duration(
            microseconds: max(endInclusive.inMicroseconds,
                otherRange.endInclusive.inMicroseconds)));
  }

  DurationRange withStart(Duration newStart) =>
      DurationRange(newStart, endInclusive);

  DurationRange withEnd(Duration newEndInclusive) =>
      DurationRange(start, newEndInclusive);

  DurationRange withOffset(Duration offset) =>
      DurationRange(start + offset, endInclusive + offset);
}

extension DurationRangeX on Duration {
  /// Creates a [DurationRange] from this [Duration] value
  /// to the specified [endInclusive] value.
  DurationRange rangeTo(Duration endInclusive) =>
      DurationRange(this, endInclusive);

  /// Creates a [DurationRange] from [Duration.zero] to this [Duration]
  DurationRange asRange() => DurationRange(Duration.zero, this);
}

extension DurationClamp on Duration {
  Duration clampToRange(DurationRange range) =>
      clamp(min: range.start, max: range.endInclusive);
}
