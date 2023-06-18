import '../_index.dart';

class NumRangeMatchAction<T> extends MatchAction<T> {
  final num? min;
  final num? max;
  final num? Function(T)? numExtractor;

  NumRangeMatchAction({
    required super.key,
    this.min,
    this.max,
    this.numExtractor,
  }) : super(
          isEnabled: min != null || max != null,
          predicate: (item) {
            final number = numExtractor?.call(item);
            if (number == null) {
              return false;
            }

            final isGreaterMin = min != null ? number >= min : null;
            final isLowerMax = max != null ? number <= max : null;

            if (min != null && max == null) {
              return isGreaterMin!;
            } else if (min == null && max != null) {
              return isLowerMax!;
            } else if (min != null && max != null) {
              return isGreaterMin! && isLowerMax!;
            }

            return false;
          },
        );
}
