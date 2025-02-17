import 'dart:collection';

/// {@template selectionState}
/// State for managing selection of items.
/// Provides functionality for tracking selected and staging items.
/// {@endtemplate}
class SelectionState<T> {
  /// {@macro selectionState}
  SelectionState({
    Set<T>? selected,
    Set<T>? staging,
  })  : selected = UnmodifiableSetView(selected ?? {}),
        staging = UnmodifiableSetView(staging ?? {});

  final Set<T> selected;
  final Set<T> staging;

  bool get hasSelection => selected.isNotEmpty;

  SelectionState<T> copyWith({
    Set<T>? selected,
    Set<T>? staging,
  }) =>
      SelectionState(
        selected: selected ?? this.selected,
        staging: staging ?? this.staging,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectionState<T> &&
          _setEquals(selected, other.selected) &&
          _setEquals(staging, other.staging);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(selected),
        Object.hashAll(staging),
      );

  bool _setEquals<E>(Set<E> a, Set<E> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.every(b.contains);
  }
}
