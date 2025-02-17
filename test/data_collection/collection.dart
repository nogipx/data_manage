import 'package:data_manage/data_collection.dart';
import 'package:test/test.dart';

import '_data.dart';

void main() {
  group('DataCollection State Management |', () {
    test('initial_state_is_correct', () {
      final collection = DataCollection<String>(
        data: abcCombinationsStrings,
        defaultSort: SortAction(
          (a, b) => a.compareTo(b),
          direction: SortDirection.asc,
        ),
        initialFilters: [
          FilterAction(
            key: 'filter1',
            predicate: (e) => e.contains('a'),
          ),
        ],
        initialMatchers: [
          MatchAction(
            key: 'match1',
            type: MatchActionType.and,
            predicate: (e) => e.length == 2,
          ),
        ],
      );

      collection.actualize();
      final state = collection.state;

      expect(state.originalData, equals(abcCombinationsStrings));
      expect(
        state.data,
        equals(['ab', 'ac']),
        reason: 'Должны быть применены фильтры и матчеры',
      );
      expect(state.hasFilters, isTrue);
      expect(state.hasMatchers, isTrue);
    });

    test('updates_state_when_data_changes', () {
      final collection = DataCollection<String>(
        data: ['a', 'b'],
        autoActualize: true,
      );

      collection.updateOriginalData(['c', 'd']);

      expect(
        collection.state.originalData,
        equals(['c', 'd']),
        reason: 'Оригинальные данные должны обновиться',
      );
      expect(
        collection.state.data,
        equals(['c', 'd']),
        reason: 'Текущие данные должны обновиться',
      );
    });

    test('applies_filters_in_correct_order', () {
      final collection = DataCollection<String>(
        data: abcCombinationsStrings,
      );

      collection
        ..addFilter(FilterAction(
          key: 'contains_b',
          predicate: (e) => e.contains('b'),
        ))
        ..addFilter(FilterAction(
          key: 'length_2',
          predicate: (e) => e.length == 2,
        ))
        ..actualize();

      expect(
        collection.state.data,
        equals(['ab', 'bc']),
        reason: 'Фильтры должны применяться последовательно',
      );
    });

    test('applies_matchers_after_filters', () {
      final collection = DataCollection<String>(
        data: abcCombinationsStrings,
      );

      collection
        ..addFilter(FilterAction(
          key: 'length_2',
          predicate: (e) => e.length == 2,
        ))
        ..addMatcher(MatchAction(
          key: 'contains_a',
          type: MatchActionType.and,
          predicate: (e) => e.contains('a'),
        ))
        ..actualize();

      expect(
        collection.state.data,
        equals(['ab', 'ac']),
        reason: 'Сначала применяются фильтры, затем матчеры',
      );
    });

    test('applies_sort_last', () {
      final collection = DataCollection<String>(
        data: ['bc', 'ab', 'ac'],
      );

      collection
        ..addFilter(FilterAction(
          key: 'length_2',
          predicate: (e) => e.length == 2,
        ))
        ..applySort(SortAction(
          (a, b) => a.compareTo(b),
          direction: SortDirection.asc,
        ))
        ..actualize();

      expect(
        collection.state.data,
        equals(['ab', 'ac', 'bc']),
        reason: 'Сортировка должна применяться после фильтров и матчеров',
      );
    });

    test('resets_all_operations_correctly', () {
      final collection = DataCollection<String>(
        data: abcCombinationsStrings,
      );

      collection
        ..addFilter(FilterAction(
          key: 'any',
          predicate: (e) => true,
        ))
        ..addMatcher(MatchAction(
          key: 'any',
          type: MatchActionType.and,
          predicate: (e) => true,
        ))
        ..applySort(SortAction(
          (a, b) => a.compareTo(b),
          direction: SortDirection.asc,
        ));

      collection
        ..resetFilters()
        ..resetMatchers()
        ..resetSort()
        ..actualize();

      expect(
        collection.state.data,
        equals(abcCombinationsStrings),
        reason: 'После сброса должны вернуться исходные данные',
      );
      expect(collection.state.hasFilters, isFalse);
      expect(collection.state.hasMatchers, isFalse);
      expect(collection.state.sort, isNull);
    });
  });
}
