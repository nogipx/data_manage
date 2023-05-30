import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../_index.dart';

class DataCollection<T> {
  final SortAction<T>? defaultSort;
  final StateCallback<DataCollectionState<T>>? onStateChanged;
  final StateCallback<DataCollectionState<T>>? onActualize;

  DataCollectionState<T> _state;
  DataCollectionState<T> get state => _state;

  bool get isLoading => state is DataCollectionLoadingState;

  DataCollection({
    Iterable<T> data = const [],
    this.defaultSort,
    Iterable<MatchAction<T>> initialMatchers = const [],
    Iterable<FilterAction<T>> initialFilters = const [],
    this.onStateChanged,
    this.onActualize,
  }) : _state = DataCollectionState.initial(
          data: data,
          originalData: data,
          matchers: _preprocessMatchers(initialMatchers.toList()),
          filters: _preprocessFilters(initialFilters.toList()),
        ) {
    actualize();
  }

  DataCollection.fromState({
    required DataCollectionState<T> state,
    this.defaultSort,
    this.onStateChanged,
    this.onActualize,
  }) : _state = state;

  DataCollectionState<T> _emitState(DataCollectionState<T> state) {
    _state = state;
    onStateChanged?.call(_state);
    return this.state;
  }

  DataCollectionState<T> updateOriginalData(Iterable<T> data) {
    return _emitState(_updateOriginalData(data));
  }

  DataCollectionState<T> actualize() {
    final state = _emitState(_actualize());
    onActualize?.call(state);
    return state;
  }

  DataCollectionState<T> addMatcher(MatchAction<T> matcher) {
    return _emitState(_addMatchers([matcher]));
  }

  DataCollectionState<T> addMatchers(Iterable<MatchAction<T>> matchers) {
    return _emitState(_addMatchers(matchers));
  }

  DataCollectionState<T> removeMatcher(String matcherKey) {
    return _emitState(_removeMatchers([matcherKey]));
  }

  DataCollectionState<T> removeMatchers(Iterable<String> matcherKeys) {
    return _emitState(_removeMatchers(matcherKeys));
  }

  DataCollectionState<T> resetMatchers() {
    return _emitState(_resetMatchers());
  }

  DataCollectionState<T> addFilter(FilterAction<T> filter) {
    return _emitState(_addFilters([filter]));
  }

  DataCollectionState<T> addFilters(Iterable<FilterAction<T>> filters) {
    return _emitState(_addFilters(filters));
  }

  DataCollectionState<T> removeFilter(String filterKey) {
    return _emitState(_removeFilters([filterKey]));
  }

  DataCollectionState<T> removeFilters(Iterable<String> filterKeys) {
    return _emitState(_removeFilters(filterKeys));
  }

  DataCollectionState<T> resetFilters() {
    return _emitState(_resetFilters());
  }

  DataCollectionState<T> applySort(SortAction<T> sort) {
    return _emitState(_applySort(sort));
  }

  DataCollectionState<T> applyDefaultSort() {
    if (defaultSort != null) {
      return _emitState(_applySort(defaultSort!));
    }
    return _emitState(state);
  }

  DataCollectionState<T> resetSort([
    DataCollectionSortResetMode mode = DataCollectionSortResetMode.defaultSort,
  ]) {
    return _emitState(_resetSort(mode));
  }

  DataCollectionState<T> markLoading() {
    return _emitState(
      DataCollectionLoadingState(
        originalData: state.originalData,
        data: state.data,
        filters: state.filters,
        matchers: state.matchers,
        sort: state.sort,
      ),
    );
  }

  DataCollectionUpdatedState<T> dryRunState({
    Set<MatchAction<T>>? newMatchers,
    Set<FilterAction<T>>? newFilters,
    SortAction<T>? newSort,
    DataCollectionSortResetMode? resetSort,
  }) =>
      _chainProcessData(
        useOriginalData: true,
        newMatchers: newMatchers != null
            ? IMap.fromEntries(newMatchers.map((e) => MapEntry(e.key, e)))
            : null,
        newFilters: newFilters != null
            ? IMap.fromEntries(newFilters.map((e) => MapEntry(e.key, e)))
            : null,
        newSort: newSort ?? getSortToApply(resetSort),
      );

  DataCollectionState<T> _addMatchers(Iterable<MatchAction<T>> data) {
    final matchers = state.matchers.unlockLazy;
    for (var matcher in data) {
      matchers[matcher.key] = matcher;
    }
    final newState = _chainProcessData(
      newMatchers: matchers.lock,
    );
    return newState;
  }

  DataCollectionState<T> _removeMatchers(Iterable<String> data) {
    final matchers = state.matchers.unlockLazy;
    for (var matcherKey in data) {
      matchers.remove(matcherKey);
    }
    final newState = _chainProcessData(
      newMatchers: matchers.lock,
    );
    return newState;
  }

  DataCollectionState<T> _resetMatchers() {
    final clearedMatchers = state.matchers.unlockLazy..clear();
    final newState = _chainProcessData(
      newMatchers: clearedMatchers.lock,
    );
    return newState;
  }

  DataCollectionState<T> _addFilters(Iterable<FilterAction<T>> data) {
    final filters = state.filters.unlockLazy;
    for (var filter in data) {
      filters[filter.key] = filter;
    }
    final newState = _chainProcessData(
      newFilters: filters.lock,
    );

    return newState;
  }

  DataCollectionState<T> _removeFilters(Iterable<String> data) {
    final filters = state.filters.unlockLazy;
    for (var filterKey in data) {
      filters.remove(filterKey);
    }
    final newState = _chainProcessData(
      newFilters: filters.lock,
    );
    return newState;
  }

  DataCollectionState<T> _resetFilters() {
    final clearedFilters = state.filters.unlockLazy..clear();
    final newState = _chainProcessData(
      newFilters: clearedFilters.lock,
    );
    return newState;
  }

  DataCollectionState<T> _applySort(SortAction<T> data) {
    final newState = _chainProcessData(
      newSort: data,
    );
    return newState;
  }

  DataCollectionState<T> _resetSort(DataCollectionSortResetMode? mode) {
    if (mode != null) {
      final newState = _chainProcessData(
        useOriginalData: mode == DataCollectionSortResetMode.originalSort,
        newSort: getSortToApply(mode),
      );
      return newState;
    } else {
      return state;
    }
  }

  DataCollectionState<T> _updateOriginalData(Iterable<T> data) {
    final actualState = _chainProcessData(
      useOriginalData: true,
      fromState: state.copyWith(originalData: data),
    );
    return actualState;
  }

  DataCollectionState<T> _actualize() {
    final actualState = _chainProcessData(
      fromState: state,
    );
    return actualState;
  }

  DataCollectionUpdatedState<T> _chainProcessData({
    DataCollectionState<T>? fromState,
    IMap<String, MatchAction<T>>? newMatchers,
    IMap<String, FilterAction<T>>? newFilters,
    SortAction<T>? newSort,
    bool useOriginalData = true,
  }) {
    final currentState = fromState ?? state;

    var newState = currentState.copyWith(
      data: useOriginalData ? currentState.originalData : currentState.data,
      matchers: newMatchers ?? currentState.matchers,
      filters: newFilters ?? currentState.filters,
      sort: newSort ?? currentState.sort ?? defaultSort,
    );

    final hasMatchersChanged =
        !newState.matchers.equalItemsToIMap(currentState.matchers);
    final hasFiltersChanged =
        !newState.filters.equalItemsToIMap(currentState.filters);

    if (hasMatchersChanged || useOriginalData) {
      final matchResult = _match(
        data: newState.data,
        matchers: newState.matchers.values,
      );
      newState = newState.copyWith(
        data: matchResult.matchedData,
      );
    }
    if (hasFiltersChanged || useOriginalData) {
      final filterResult = _filter(
        data: newState.data,
        filters: newState.filters.values,
      );
      newState = newState.copyWith(
        data: filterResult.filteredData,
      );
    }
    if (newState.sort != null) {
      final sortResult = _sort(
        data: newState.data,
        sort: newState.sort,
      );
      newState = newState.copyWith(
        data: sortResult.sortedData,
        sort: sortResult.appliedSort,
      );
    }

    return DataCollectionUpdatedState(
      originalData: newState.originalData,
      data: newState.data,
      filters: newState.filters,
      matchers: newState.matchers,
      sort: newState.sort,
    );
  }

  SortUseCaseResult<T> _sort({
    required Iterable<T> data,
    SortAction<T>? sort,
  }) {
    if (sort != null) {
      final sortResult = SortUseCase(
        data: data,
        sort: sort,
      ).run();

      if (sortResult.appliedSort == defaultSort) {
        return SortUseCaseResult(
          sortedData: sortResult.sortedData,
          originalData: sortResult.originalData,
          appliedSort: null,
        );
      }
      return sortResult;
    }
    return SortUseCaseResult(
      originalData: data,
      sortedData: data,
    );
  }

  MatchUseCaseResult<T> _match({
    required Iterable<T> data,
    required Iterable<MatchAction<T>> matchers,
  }) {
    final matchResult = MatchUseCase(
      data: data,
      matchers: matchers,
    ).run();

    return matchResult;
  }

  FilterUseCaseResult<T> _filter({
    required Iterable<T> data,
    required Iterable<FilterAction<T>> filters,
  }) {
    final filterResult = FilterUseCase(
      data: data,
      filters: filters,
    ).run();
    return filterResult;
  }

  SortAction<T>? getSortToApply([DataCollectionSortResetMode? mode]) {
    final sortToApply = () {
      if (mode == DataCollectionSortResetMode.originalSort) {
        return null;
      } else if (mode == DataCollectionSortResetMode.defaultSort) {
        return defaultSort;
      } else {
        return state.sort;
      }
    }();
    return sortToApply;
  }

  static IMap<String, MatchAction<T>> _preprocessMatchers<T>(
      List<MatchAction<T>> matchers) {
    return IMap.fromEntries(matchers.map((e) => MapEntry(e.key, e)));
  }

  static IMap<String, FilterAction<T>> _preprocessFilters<T>(
      List<FilterAction<T>> filters) {
    return IMap.fromEntries(filters.map((e) => MapEntry(e.key, e)));
  }
}
