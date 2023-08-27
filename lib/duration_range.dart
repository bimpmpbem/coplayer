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

  DurationRange shrinkToFit(DurationRange otherRange) {
    return DurationRange(
      start.clampToRange(otherRange),
      endInclusive.clampToRange(otherRange),
    );
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
  // TODO rename to rangeToHere (w/ optional start Duration.zero)?
  DurationRange asRange() => DurationRange(Duration.zero, this);

  /// Creates a [DurationRange] with this [Duration] at the center, and a total
  /// length of 2*[margin]
  DurationRange addMargin(Duration margin) =>
      DurationRange(this - margin, this + margin);
}

extension DurationClamp on Duration {
  Duration clampToRange(DurationRange range) =>
      clamp(min: range.start, max: range.endInclusive);
}
