import 'package:data_manage/data_collection.dart';
import 'package:test/test.dart';

import '../_data.dart';

void main() {
  test('matches_with_or_type_returns_items_matching_any_condition', () {
    final sut = MatchUseCase<String>(
      data: abcCombinationsStrings,
      matchers: [
        MatchAction(
          key: '1',
          type: MatchActionType.or,
          predicate: (e) => e.contains('a'),
        ),
        MatchAction(
          key: '2',
          type: MatchActionType.or,
          predicate: (e) => e.contains('b'),
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.matchedData,
      equals(['a', 'b', 'ab', 'bc', 'ac']),
      reason: 'Должны быть возвращены строки, содержащие a ИЛИ b',
    );
    expect(result.appliedMatchers.length, equals(2));
  });

  test('matches_with_and_type_returns_items_matching_all_conditions', () {
    final sut = MatchUseCase<String>(
      data: abcCombinationsStrings,
      matchers: [
        MatchAction(
          key: '1',
          type: MatchActionType.and,
          predicate: (e) => e.contains('a'),
        ),
        MatchAction(
          key: '2',
          type: MatchActionType.and,
          predicate: (e) => e.contains('b'),
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.matchedData,
      equals(['ab']),
      reason: 'Должна быть возвращена строка, содержащая и a, И b',
    );
    expect(result.appliedMatchers.length, equals(2));
  });

  test('disabled_matchers_are_ignored', () {
    final sut = MatchUseCase<String>(
      data: abcCombinationsStrings,
      matchers: [
        MatchAction(
          key: '1',
          type: MatchActionType.and,
          predicate: (e) => e.contains('a'),
          isEnabled: false,
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.matchedData,
      equals(abcCombinationsStrings),
      reason: 'Отключенные матчеры не должны влиять на результат',
    );
    expect(result.appliedMatchers, isEmpty);
  });

  test('mixed_and_or_matchers_are_applied_in_correct_order', () {
    final sut = MatchUseCase<String>(
      data: abcCombinationsStrings,
      matchers: [
        MatchAction(
          key: '1',
          type: MatchActionType.or,
          predicate: (e) => e.contains('a'),
        ),
        MatchAction(
          key: '2',
          type: MatchActionType.and,
          predicate: (e) => e.length == 2,
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(
      result.matchedData,
      equals(['ab', 'ac']),
      reason: 'Должны быть возвращены строки длины 2, содержащие a',
    );
    expect(result.appliedMatchers.length, equals(2));
  });

  test('empty_data_returns_empty_result', () {
    final sut = MatchUseCase<String>(
      data: [],
      matchers: [
        MatchAction(
          key: '1',
          type: MatchActionType.and,
          predicate: (e) => true,
        ),
      ],
    );

    final result = sut.run();

    expect(result.originalData, isEmpty);
    expect(result.matchedData, isEmpty);
    expect(result.appliedMatchers.length, equals(1));
  });

  test('no_matchers_returns_original_data', () {
    final sut = MatchUseCase<String>(
      data: abcCombinationsStrings,
      matchers: [],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.matchedData, equals(abcCombinationsStrings));
    expect(result.appliedMatchers, isEmpty);
  });
}
