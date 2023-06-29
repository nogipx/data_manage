import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

import '../_data.dart';

void main() {
  test('Filtering is correct', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [
        FilterAction(
          key: '',
          predicate: (e) => e.contains('a'),
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.filteredData, equals(['a', 'ab', 'ac']));
    expect(result.appliedFilters.length, equals(1));
  });

  test('Disabled filters does not applied', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [
        FilterAction(
          key: '',
          predicate: (e) => e.contains('a'),
          isEnabled: false,
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.filteredData, equals(abcCombinationsStrings));
    expect(result.appliedFilters.length, equals(0));
  });

  test('Many filters all applied', () {
    final sut = FilterUseCase<String>(
      data: abcCombinationsStrings,
      filters: [
        FilterAction(
          key: '',
          predicate: (e) => e.contains('b'),
        ),
        FilterAction(
          key: '',
          predicate: (e) => !e.contains('a'),
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.filteredData, equals(['b', 'bc']));
    expect(result.appliedFilters.length, equals(2));
  });
}
