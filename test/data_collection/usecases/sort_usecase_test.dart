import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

void main() {
  group('Sorting usecase', () {
    test('Sort ascendant', () {
      final data = [9, 8, 7, 6, 5, 4, 3, 2, 1];
      final sut = SortUseCase<int>(
        data: data,
        sort: SortAction(
          (a, b) => a.compareTo(b),
          direction: SortDirection.asc,
        ),
      );

      final result = sut.run();

      expect(result.originalData, equals(data));
      expect(result.sortedData, equals([1, 2, 3, 4, 5, 6, 7, 8, 9]));
      expect(result.appliedSort, isNotNull);
    });

    test('Sort descendant', () {
      final data = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      final sut = SortUseCase<int>(
        data: data,
        sort: SortAction(
          (a, b) => a.compareTo(b),
          direction: SortDirection.desc,
        ),
      );

      final result = sut.run();

      expect(result.originalData, equals(data));
      expect(result.sortedData, equals([9, 8, 7, 6, 5, 4, 3, 2, 1]));
      expect(result.appliedSort, isNotNull);
    });
  });
}
