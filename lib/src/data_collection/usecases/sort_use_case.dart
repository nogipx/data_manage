import '../_index.dart';

class SortUseCaseResult<T> {
  final Iterable<T> originalData;
  final Iterable<T> sortedData;
  final SortAction<T>? appliedSort;

  const SortUseCaseResult({
    this.originalData = const [],
    this.sortedData = const [],
    this.appliedSort,
  });
}

class SortUseCase<T> implements DataCollectionUseCase<SortUseCaseResult<T>> {
  final Iterable<T> data;
  final SortAction<T> sort;

  const SortUseCase({
    required this.data,
    required this.sort,
  });

  /// Сортирует данные.
  ///
  /// Если [sort] указан, то перезаписывает установленную сортировку
  /// и применяет к фильтрованным данным.
  ///
  /// Если [sort] не указан и есть текущая установленная сортировка,
  /// то применяет текущую сортировку.
  ///
  /// Если [sort] не указан и нет текущей установленной сортировки,
  /// то ничего не происходит.
  @override
  SortUseCaseResult<T> run() {
    final targetSort = sort;

    if (data.isNotEmpty) {
      final sorted = List<T>.from(data);
      sorted.sort((a, b) => targetSort.comparator(a, b) * targetSort.direction.compareValue);

      return SortUseCaseResult(
        originalData: data,
        sortedData: sorted,
        appliedSort: targetSort,
      );
    }

    return SortUseCaseResult(
      originalData: data,
      sortedData: data,
    );
  }
}
