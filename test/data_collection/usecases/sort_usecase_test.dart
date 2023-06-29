import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

import '../_data.dart';

void main() {
  test('Sort ascendant', () {
    final data = naturalNumbersDesc;
    final sut = SortUseCase<int>(
      data: data,
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.asc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals(data));
    expect(result.sortedData, equals(naturalNumbersAsc));
    expect(result.appliedSort, isNotNull);
  });

  test('Sort descendant', () {
    final data = naturalNumbersAsc;
    final sut = SortUseCase<int>(
      data: data,
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.desc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals(data));
    expect(result.sortedData, equals(naturalNumbersDesc));
    expect(result.appliedSort, isNotNull);
  });

  test('Empty data produces empty result', () {
    final sut = SortUseCase<int>(
      data: [],
      sort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.desc,
      ),
    );

    final result = sut.run();

    expect(result.originalData, equals([]));
    expect(result.sortedData, equals([]));
    expect(result.appliedSort, isNull);
  });
}
