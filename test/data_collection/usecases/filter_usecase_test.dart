import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

void main() {
  group('Filtering usecase', () {
    test('Filtering is correct', () {
      final data = ['aaa', 'aab', 'aac', 'bbb', 'ccc'];
      final sut = FilterUseCase<String>(
        data: data,
        filters: [
          FilterAction(
            key: '',
            predicate: (e) => e.contains('a'),
          ),
        ],
      );

      final result = sut.run();

      expect(result.originalData, equals(data));
      expect(result.filteredData, equals(['aaa', 'aab', 'aac']));
      expect(result.appliedFilters.length, equals(1));
    });

    test('Disabled filters does not applied', () {
      final data = ['aaa', 'aab', 'aac', 'bbb', 'ccc'];
      final sut = FilterUseCase<String>(
        data: data,
        filters: [
          FilterAction(
            key: '',
            predicate: (e) => e.contains('a'),
            isEnabled: false,
          ),
        ],
      );

      final result = sut.run();

      expect(result.originalData, equals(data));
      expect(result.filteredData, equals(data));
      expect(result.appliedFilters.length, equals(0));
    });

    test('Many filters all applied', () {
      final data = ['aaa', 'aab', 'aac', 'bbb', 'ccc'];
      final sut = FilterUseCase<String>(
        data: data,
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

      expect(result.originalData, equals(data));
      expect(result.filteredData, equals(['bbb']));
      expect(result.appliedFilters.length, equals(2));
    });
  });
}
