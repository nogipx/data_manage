import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../_index.dart';

part 'data_collection_state.freezed.dart';

@Freezed(copyWith: true, makeCollectionsUnmodifiable: true)
class DataCollectionState<T> with _$DataCollectionState<T> {
  const DataCollectionState._();

  const factory DataCollectionState.initial({
    required Iterable<T> originalData,
    required Iterable<T> data,
    required IMap<String, FilterAction<T>> filters,
    required IMap<String, MatchAction<T>> matchers,
    SortAction<T>? sort,
  }) = DataCollectionInitialState<T>;

  const factory DataCollectionState.loading({
    required Iterable<T> originalData,
    required Iterable<T> data,
    required IMap<String, FilterAction<T>> filters,
    required IMap<String, MatchAction<T>> matchers,
    SortAction<T>? sort,
  }) = DataCollectionLoadingState<T>;

  const factory DataCollectionState.updated({
    required Iterable<T> originalData,
    required Iterable<T> data,
    required IMap<String, FilterAction<T>> filters,
    required IMap<String, MatchAction<T>> matchers,
    SortAction<T>? sort,
  }) = DataCollectionUpdatedState<T>;

  int get dataCount => data.length;

  bool containsMatcher(String key) => matchers.containsKey(key);
  bool containsFilter(String key) => filters.containsKey(key);

  bool get hasMatchers => matchers.any((key, value) => value.isEnabled);
  bool get hasFilters => filters.any((key, value) => value.isEnabled);
}

enum DataCollectionSortResetMode {
  originalSort,
  defaultSort,
}
