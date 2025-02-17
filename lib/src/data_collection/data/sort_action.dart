class SortAction<T> {
  final Comparator<T> comparator;
  final SortDirection direction;
  final String name;
  final String ascString;
  final String descString;

  const SortAction(
    this.comparator, {
    this.name = '',
    this.ascString = 'По возрастанию',
    this.descString = 'По убыванию',
    this.direction = SortDirection.asc,
  });

  SortAction<T> copyWith({
    SortDirection? direction,
  }) =>
      SortAction(
        comparator,
        direction: direction ?? this.direction,
        name: name,
      );

  @override
  bool operator ==(Object other) => other is SortAction<T> && comparator == other.comparator;

  @override
  int get hashCode => Object.hashAll([comparator]);
}

enum SortDirection {
  asc(1),
  desc(-1);

  final int compareValue;

  const SortDirection(this.compareValue);
}
