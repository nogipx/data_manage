import 'dart:collection';

import '../_index.dart';

class DataCollection<T> {
  final SortAction<T>? defaultSort;

  /// Controls to automatically pass
  /// new state to listeners.
  final bool autoActualize;

  DataCollectionState<T> _state;

  DataCollectionState<T> get state => _state;

  DataCollectionListener<T>? _listener;

  bool get hasCollectionListener => _listener != null;

  bool get isLoading => state is DataCollectionLoadingState;

  DataCollection({
    Iterable<T> data = const [],
    this.defaultSort,
    Iterable<MatchAction<T>> initialMatchers = const [],
    Iterable<FilterAction<T>> initialFilters = const [],
    this.autoActualize = true,
    DataCollectionListener<T>? listener,
  })  : _state = DataCollectionState.initial(
          data: data,
          originalData: data,
          matchers: _preprocessMatchers(initialMatchers.toList()),
          filters: _preprocessFilters(initialFilters.toList()),
        ),
        _listener = listener {
    actualize();
  }

  DataCollection.fromState({
    required DataCollectionState<T> state,
    this.defaultSort,
    DataCollectionStateCallback<DataCollectionState<T>>? onStateChanged,
    DataCollectionStateCallback<DataCollectionState<T>>? onActualize,
    this.autoActualize = true,
  }) : _state = state;

  DataCollectionState<T> _emitState(DataCollectionState<T> state) {
    _state = state;
    _listener?.onStateChanged(_state);
    if (autoActualize) {
      _state = _chainProcessData(fromState: _state);
      _listener?.onActualize(_state);
    }
    return _state;
  }

  DataCollectionState<T> actualize() {
    final state = _emitState(_actualize());
    if (!autoActualize) {
      _listener?.onActualize(_state);
    }
    return state;
  }

  DataCollectionState<T> updateOriginalData(Iterable<T> data) {
    return _emitState(_updateOriginalData(data));
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
            ? UnmodifiableMapView(Map.fromEntries(newMatchers.map((e) => MapEntry(e.key, e))))
            : null,
        newFilters: newFilters != null
            ? UnmodifiableMapView(Map.fromEntries(newFilters.map((e) => MapEntry(e.key, e))))
            : null,
        newSort: newSort ?? _getSortToApply(resetSort),
      );

  DataCollectionState<T> _addMatchers(Iterable<MatchAction<T>> data) {
    final matchers = Map.of(state.matchers);
    for (var matcher in data) {
      matchers[matcher.key] = matcher;
    }
    final newState = _chainProcessData(
      newMatchers: UnmodifiableMapView(matchers),
    );
    return newState;
  }

  DataCollectionState<T> _removeMatchers(Iterable<String> data) {
    final matchers = Map.of(state.matchers);
    for (var matcherKey in data) {
      matchers.remove(matcherKey);
    }
    final newState = _chainProcessData(
      newMatchers: UnmodifiableMapView(matchers),
    );
    return newState;
  }

  DataCollectionState<T> _resetMatchers() {
    final newState = _chainProcessData(
      newMatchers: UnmodifiableMapView({}),
    );
    return newState;
  }

  DataCollectionState<T> _addFilters(Iterable<FilterAction<T>> data) {
    final filters = Map.of(state.filters);
    for (var filter in data) {
      filters[filter.key] = filter;
    }
    final newState = _chainProcessData(
      newFilters: UnmodifiableMapView(filters),
    );
    return newState;
  }

  DataCollectionState<T> _removeFilters(Iterable<String> data) {
    final filters = Map.of(state.filters);
    for (var filterKey in data) {
      filters.remove(filterKey);
    }
    final newState = _chainProcessData(
      newFilters: UnmodifiableMapView(filters),
    );
    return newState;
  }

  DataCollectionState<T> _resetFilters() {
    final newState = _chainProcessData(
      newFilters: UnmodifiableMapView({}),
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
        newSort: _getSortToApply(mode),
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
    Map<String, MatchAction<T>>? newMatchers,
    Map<String, FilterAction<T>>? newFilters,
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

    final hasMatchersChanged = !_mapEquals(newState.matchers, currentState.matchers);
    final hasFiltersChanged = !_mapEquals(newState.filters, currentState.filters);

    if (hasMatchersChanged || useOriginalData) {
      final matchResult = MatchUseCase(
        data: newState.data,
        matchers: newState.matchers.values,
      ).run();
      newState = newState.copyWith(
        data: matchResult.matchedData,
      );
    }

    if (hasFiltersChanged || useOriginalData) {
      final filterResult = FilterUseCase(
        data: newState.data,
        filters: newState.filters.values,
      ).run();
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

  SortAction<T>? _getSortToApply([DataCollectionSortResetMode? mode]) {
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

  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.entries.every((e) => b.containsKey(e.key) && b[e.key] == e.value);
  }

  static Map<String, MatchAction<T>> _preprocessMatchers<T>(List<MatchAction<T>> matchers) {
    return UnmodifiableMapView(Map.fromEntries(matchers.map((e) => MapEntry(e.key, e))));
  }

  static Map<String, FilterAction<T>> _preprocessFilters<T>(List<FilterAction<T>> filters) {
    return UnmodifiableMapView(Map.fromEntries(filters.map((e) => MapEntry(e.key, e))));
  }
}
