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

  // TODO add valuesEquals? useful for testing

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

extension ObjectToSnapshot<T> on T {
  Snapshot<T> snapshot([DateTime? time]) =>
      Snapshot(time ?? DateTime.now(), this);
}
