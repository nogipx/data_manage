import '../_index.dart';

class FilterAction<T> {
  final String key;
  final DataCollectionPredicate<T> predicate;
  final bool isEnabled;

  const FilterAction({
    required this.key,
    required this.predicate,
    this.isEnabled = true,
  });

  @override
  bool operator ==(Object other) =>
      other is FilterAction<T> && key == other.key && predicate == other.predicate;

  @override
  int get hashCode => Object.hashAll([key, predicate]);

  FilterAction<T> copyWith({
    bool? isEnabled,
  }) =>
      FilterAction<T>(
        key: key,
        predicate: predicate,
        isEnabled: isEnabled ?? this.isEnabled,
      );
}
