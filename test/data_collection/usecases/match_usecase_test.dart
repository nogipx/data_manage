import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

void main() {
  group('Matching usecase', () {
    test('Matching with "or"/"and" types', () async {
      final data = ['ac', 'bbb', 'ccc', 'aab', 'bbc', 'ab'];
      final sut = MatchUseCase<String>(
        data: data,
        matchers: [
          MatchAction(
            key: '',
            type: MatchActionType.or,
            predicate: (e) => e.length == 2,
          ),
          MatchAction(
            key: '',
            type: MatchActionType.and,
            predicate: (e) => e.contains('c'),
          )
        ],
      );

      final result = sut.run();
      final count = await sut.countMatchedItems();

      expect(result.originalData, equals(data));
      expect(result.matchedData, equals(['ac', 'ccc', 'bbc', 'ab']));
      expect(count, equals(4));
      expect(result.appliedMatchers.length, equals(2));
    });

    test('Disabled matchers does not applied', () {
      final data = ['ac', 'bbb', 'ccc', 'aab', 'bbc', 'ab'];
      final sut = MatchUseCase<String>(
        data: data,
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

      expect(result.originalData, equals(data));
      expect(result.matchedData, equals(data));
      expect(result.appliedMatchers.length, equals(0));
    });
  });
}
