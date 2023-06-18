import '../_index.dart';

class FilterUseCaseResult<T> {
  final Iterable<T> originalData;
  final Iterable<T> filteredData;
  final Iterable<FilterAction<T>> appliedFilters;

  const FilterUseCaseResult({
    this.originalData = const [],
    this.filteredData = const [],
    this.appliedFilters = const [],
  });
}

class FilterUseCase<T> implements UseCase<FilterUseCaseResult<T>> {
  final Iterable<T> data;
  final Iterable<FilterAction<T>> filters;

  const FilterUseCase({
    required this.data,
    this.filters = const [],
  });

  @override
  FilterUseCaseResult<T> run() {
    final enabledFilters = filters.where((e) => e.isEnabled);

    if (data.isNotEmpty && enabledFilters.isNotEmpty) {
      bool composedPredicate(T item) =>
          enabledFilters.every((e) => e.predicate(item));

      final filteredData = data.where((item) {
        return composedPredicate(item);
      });

      return FilterUseCaseResult(
        originalData: data,
        filteredData: filteredData,
        appliedFilters: enabledFilters,
      );
    }

    return FilterUseCaseResult(
      originalData: data,
      filteredData: data,
      appliedFilters: const [],
    );
  }
}
