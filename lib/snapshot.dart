class Snapshot<T> {
  final T value;
  final DateTime timestamp;

  const Snapshot(this.timestamp, this.value);

  Snapshot.now(T value) : this(DateTime.now(), value);

  Snapshot<T> copyWith({DateTime? timestamp, T? value}) =>
      Snapshot(timestamp ?? this.timestamp, value ?? this.value);

  @override
  String toString() {
    return 'Snapshot{value: $value, timestamp: $timestamp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Snapshot &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          timestamp == other.timestamp;

  @override
  int get hashCode => value.hashCode ^ timestamp.hashCode;
}

extension DateTimeSnapshotEstimateNow on Snapshot<DateTime> {
  DateTime estimateNow() {
    final timePassed = DateTime.now().difference(timestamp);
    return value.add(timePassed);
  }
}

extension DurationSnapshotEstimateNow on Snapshot<Duration> {
  Duration estimateNow() {
    final timePassed = DateTime.now().difference(timestamp);
    return value + timePassed;
  }
}

extension ObjectToSnapshot<T> on T {
  Snapshot<T> snapshot([DateTime? time]) =>
      Snapshot(time ?? DateTime.now(), this);
}
