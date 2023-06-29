import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

import '../_data.dart';

void main() {
  test('Matching with "or"/"and" types', () async {
    final data = abcCombinationsStrings;
    final sut = MatchUseCase<String>(
      data: data,
      matchers: [
        MatchAction(
          key: '1',
          type: MatchActionType.or,
          predicate: (e) => e.contains('a'),
        ),
        MatchAction(
          key: '2',
          type: MatchActionType.and,
          predicate: (e) => e.contains('c'),
        ),
        MatchAction(
          key: '3',
          type: MatchActionType.and,
          predicate: (e) => e.length == 2,
        ),
      ],
    );

    final result = sut.run();
    final count = sut.countMatchedItems();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.matchedData, equals(['a', 'ab', 'bc', 'ac']));
    expect(count, equals(4));
    expect(result.appliedMatchers.length, equals(3));
  });

  test('Disabled matchers does not applied', () {
    final sut = MatchUseCase<String>(
      data: abcCombinationsStrings,
      matchers: [
        MatchAction(
          key: '',
          type: MatchActionType.and,
          predicate: (e) => true,
          isEnabled: false,
        ),
        MatchAction(
          key: '',
          type: MatchActionType.or,
          predicate: (e) => true,
          isEnabled: false,
        )
      ],
    );

    final result = sut.run();

    expect(result.originalData, equals(abcCombinationsStrings));
    expect(result.matchedData, equals(abcCombinationsStrings));
    expect(result.appliedMatchers.length, equals(0));
  });
}
