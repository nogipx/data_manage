import 'package:data_manage/data_collection.dart';
import 'package:test/test.dart';

import '../_data.dart';

void main() {
  test('sorts_ascending_order_correctly', () {
    final sut = SortUseCase<int>(
      data: naturalNumbersDesc,
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.asc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals(naturalNumbersDesc));
    expect(
      result.sortedData,
      equals(naturalNumbersAsc),
      reason: 'Числа должны быть отсортированы по возрастанию',
    );
    expect(result.appliedSort, isNotNull);
  });

  test('sorts_descending_order_correctly', () {
    final sut = SortUseCase<int>(
      data: naturalNumbersAsc,
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.desc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals(naturalNumbersAsc));
    expect(
      result.sortedData,
      equals(naturalNumbersDesc),
      reason: 'Числа должны быть отсортированы по убыванию',
    );
    expect(result.appliedSort, isNotNull);
  });

  test('empty_data_returns_empty_result', () {
    final sut = SortUseCase<int>(
      data: [],
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.desc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, isEmpty);
    expect(result.sortedData, isEmpty);
    expect(result.appliedSort, isNull);
  });

  test('single_element_returns_same_element', () {
    final sut = SortUseCase<int>(
      data: [42],
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.desc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals([42]));
    expect(result.sortedData, equals([42]));
    expect(result.appliedSort, isNotNull);
  });

  test('equal_elements_preserve_order', () {
    final data = [1, 1, 1];
    final sut = SortUseCase<int>(
      data: data,
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.asc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals(data));
    expect(
      result.sortedData,
      equals(data),
      reason: 'Равные элементы должны сохранять порядок',
    );
    expect(result.appliedSort, isNotNull);
  });
}
