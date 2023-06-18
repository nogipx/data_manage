import 'package:data_manage/data_manage.dart';
import 'package:test/test.dart';

void main() {
  test('Initial settings for collection are applied', () {
    final data = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    final sut = DataCollection<int>(
      data: data,
      defaultSort: SortAction(
        (a, b) => a.compareTo(b),
        direction: SortDirection.desc,
      ),
      initialFilters: [
        FilterAction(
          key: 'filter1',
          predicate: (e) => e > 2,
        ),
      ],
      initialMatchers: [
        MatchAction(
          key: 'match1',
          type: MatchActionType.and,
          predicate: (e) => e % 2 == 0,
        ),
        MatchAction(
          key: 'match2',
          type: MatchActionType.or,
          predicate: (e) => e == 9,
        ),
      ],
    );

    sut.actualize();

    final state = sut.state;
    expect(state.originalData, equals(data));
    expect(state.data, equals([9, 8, 6, 4]));
    expect(state.hasFilters, equals(true));
    expect(state.hasMatchers, equals(true));
    expect(state.sort, isNull);
  });
}
