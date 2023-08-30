import 'package:dartx/dartx.dart';

extension DurationPrint on Duration {
  String toStringCompact() {
    if (isNegative) {
      return "-${toString().split('.').first.removePrefix('-0:')}";
    } else {
      return toString().split('.').first.removePrefix('0:');
    }
  }
}
