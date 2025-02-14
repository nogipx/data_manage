import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

import '../_data.dart';

void main() {
  test('single_filter_returns_matching_items', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [
        FilterAction(
          key: 'contains_a',
          predicate: (e) => e.contains('a'),
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.filteredData,
      equals(['a', 'ab', 'ac']),
      reason: 'Должны быть возвращены строки, содержащие букву a',
    );
    expect(result.appliedFilters.length, equals(1));
  });

  test('disabled_filter_is_not_applied', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [
        FilterAction(
          key: 'contains_a',
          predicate: (e) => e.contains('a'),
          isEnabled: false,
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.filteredData,
      equals(abcCombinationsStrings),
      reason: 'Отключенный фильтр не должен влиять на результат',
    );
    expect(result.appliedFilters, isEmpty);
  });

  test('multiple_filters_are_applied_sequentially', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [
        FilterAction(
          key: 'contains_b',
          predicate: (e) => e.contains('b'),
        ),
        FilterAction(
          key: 'no_a',
          predicate: (e) => !e.contains('a'),
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.filteredData,
      equals(['b', 'bc']),
      reason: 'Должны быть возвращены строки с b, но без a',
    );
    expect(result.appliedFilters.length, equals(2));
  });

  test('empty_data_returns_empty_result', () {
    final sut = FilterUseCase<String>(
      data: [],
      filters: [
        FilterAction(
          key: 'any',
          predicate: (e) => true,
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, isEmpty);
    expect(result.filteredData, isEmpty);
    expect(result.appliedFilters.length, equals(1));
  });

  test('no_filters_returns_original_data', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.filteredData, equals(abcCombinationsStrings));
    expect(result.appliedFilters, isEmpty);
  });

  test('filter_preserves_order_of_matched_items', () {
    final data = ['abc', 'bcd', 'cde', 'def'];
    final sut = FilterUseCase<String>(
      data: data,
      filters: [
        FilterAction(
          key: 'contains_c',
          predicate: (e) => e.contains('c'),
        ),
      ],
    );

    final result = sut.run();

    expect(
      result.filteredData.toList(),
      equals(['abc', 'bcd', 'cde']),
      reason: 'Порядок элементов должен сохраняться после фильтрации',
    );
  });
}
