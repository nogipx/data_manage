import 'dart:collection';

import '../_index.dart';

/// {@template dataCollectionState}
/// Base class for all data collection states.
/// Provides common functionality for data management and filtering.
/// {@endtemplate}
abstract class DataCollectionState<T> {
  /// {@macro dataCollectionState}
  DataCollectionState({
    required this.originalData,
    required this.data,
    Map<String, FilterAction<T>>? filters,
    Map<String, MatchAction<T>>? matchers,
    this.sort,
  })  : filters = UnmodifiableMapView(filters ?? {}),
        matchers = UnmodifiableMapView(matchers ?? {});

  /// Creates initial state with default values
  static DataCollectionState<T> initial<T>({
    required Iterable<T> originalData,
    required Iterable<T> data,
    Map<String, FilterAction<T>>? filters,
    Map<String, MatchAction<T>>? matchers,
    SortAction<T>? sort,
  }) =>
      DataCollectionInitialState(
        originalData: originalData,
        data: data,
        filters: filters,
        matchers: matchers,
        sort: sort,
      );

  final Iterable<T> originalData;
  final Iterable<T> data;
  final Map<String, FilterAction<T>> filters;
  final Map<String, MatchAction<T>> matchers;
  final SortAction<T>? sort;

  int get dataCount => data.length;

  bool containsMatcher(String key) => matchers.containsKey(key);
  bool containsFilter(String key) => filters.containsKey(key);

  bool get hasMatchers => matchers.values.any((value) => value.isEnabled);
  bool get hasFilters => filters.values.any((value) => value.isEnabled);

  DataCollectionState<T> copyWith({
    Iterable<T>? originalData,
    Iterable<T>? data,
    Map<String, FilterAction<T>>? filters,
    Map<String, MatchAction<T>>? matchers,
    SortAction<T>? sort,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataCollectionState<T> &&
          _iterableEquals(originalData, other.originalData) &&
          _iterableEquals(data, other.data) &&
          _mapEquals(filters, other.filters) &&
          _mapEquals(matchers, other.matchers) &&
          sort == other.sort;

  @override
  int get hashCode => Object.hash(
        Object.hashAll(originalData),
        Object.hashAll(data),
        Object.hashAll(filters.entries),
        Object.hashAll(matchers.entries),
        sort,
      );

  bool _iterableEquals(Iterable<T> a, Iterable<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    final ait = a.iterator;
    final bit = b.iterator;
    while (ait.moveNext()) {
      bit.moveNext();
      if (ait.current != bit.current) return false;
    }
    return true;
  }

  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.entries.every((e) => b.containsKey(e.key) && b[e.key] == e.value);
  }
}

/// {@template dataCollectionInitialState}
/// Initial state of data collection.
/// Used when collection is first created.
/// {@endtemplate}
class DataCollectionInitialState<T> extends DataCollectionState<T> {
  /// {@macro dataCollectionInitialState}
  DataCollectionInitialState({
    required super.originalData,
    required super.data,
    super.filters,
    super.matchers,
    super.sort,
  });

  @override
  DataCollectionState<T> copyWith({
    Iterable<T>? originalData,
    Iterable<T>? data,
    Map<String, FilterAction<T>>? filters,
    Map<String, MatchAction<T>>? matchers,
    SortAction<T>? sort,
  }) =>
      DataCollectionInitialState(
        originalData: originalData ?? this.originalData,
        data: data ?? this.data,
        filters: filters ?? this.filters,
        matchers: matchers ?? this.matchers,
        sort: sort ?? this.sort,
      );
}

/// {@template dataCollectionLoadingState}
/// Loading state of data collection.
/// Used when collection is being updated.
/// {@endtemplate}
class DataCollectionLoadingState<T> extends DataCollectionState<T> {
  /// {@macro dataCollectionLoadingState}
  DataCollectionLoadingState({
    required super.originalData,
    required super.data,
    required Map<String, FilterAction<T>> filters,
    required Map<String, MatchAction<T>> matchers,
    super.sort,
  }) : super(filters: filters, matchers: matchers);

  @override
  DataCollectionState<T> copyWith({
    Iterable<T>? originalData,
    Iterable<T>? data,
    Map<String, FilterAction<T>>? filters,
    Map<String, MatchAction<T>>? matchers,
    SortAction<T>? sort,
  }) =>
      DataCollectionLoadingState(
        originalData: originalData ?? this.originalData,
        data: data ?? this.data,
        filters: filters ?? this.filters,
        matchers: matchers ?? this.matchers,
        sort: sort ?? this.sort,
      );
}

/// {@template dataCollectionUpdatedState}
/// Updated state of data collection.
/// Used when collection has been successfully updated.
/// {@endtemplate}
class DataCollectionUpdatedState<T> extends DataCollectionState<T> {
  /// {@macro dataCollectionUpdatedState}
  DataCollectionUpdatedState({
    required super.originalData,
    required super.data,
    required Map<String, FilterAction<T>> filters,
    required Map<String, MatchAction<T>> matchers,
    super.sort,
  }) : super(filters: filters, matchers: matchers);

  @override
  DataCollectionState<T> copyWith({
    Iterable<T>? originalData,
    Iterable<T>? data,
    Map<String, FilterAction<T>>? filters,
    Map<String, MatchAction<T>>? matchers,
    SortAction<T>? sort,
  }) =>
      DataCollectionUpdatedState(
        originalData: originalData ?? this.originalData,
        data: data ?? this.data,
        filters: filters ?? this.filters,
        matchers: matchers ?? this.matchers,
        sort: sort ?? this.sort,
      );
}

enum DataCollectionSortResetMode {
  originalSort,
  defaultSort,
}
