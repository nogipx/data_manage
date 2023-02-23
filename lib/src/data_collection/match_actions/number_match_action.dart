import '../_index.dart';

class NumberMatchAction<T> extends MatchAction<T> {
  final num? min;
  final num? max;
  final num? Function(T)? numExtractor;

  NumberMatchAction({
    required super.key,
    this.min,
    this.max,
    this.numExtractor,
  }) : super(
          isEnabled: min != null || max != null,
          predicate: (item) {
            final sku = numExtractor?.call(item);
            if (sku == null) {
              return false;
            }

            final isGreaterMin = min != null ? sku >= min : null;
            final isLowerMax = max != null ? sku <= max : null;

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
