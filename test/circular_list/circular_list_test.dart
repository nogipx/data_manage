import 'package:data_manage/src/circular_list/circular_list.dart';
import 'package:test/test.dart';

void main() {
  group('CircularList', () {
    late CircularList<int> list;

    setUp(() {
      list = CircularList<int>(5);
    });

    test('initialization', () {
      expect(list.isEmpty, isTrue);
      expect(list.length, equals(0));
      expect(list.capacity, equals(5));
      expect(list.hasSpace, isTrue);
      expect(list.isFull, isFalse);
    });

    group('basic operations', () {
      test('adding elements', () {
        list.add(1);
        expect(list.length, equals(1));
        expect(list[0], equals(1));
        expect(list.latest, equals(1));
        expect(list.oldest, equals(1));

        list.addAll([2, 3, 4]);
        expect(list.length, equals(4));
        expect(list.toList(), equals([1, 2, 3, 4]));
        expect(list.latest, equals(4));
        expect(list.oldest, equals(1));

        // Test index-based modification
        list[2] = 10;
        expect(list.toList(), equals([1, 2, 10, 4]));
        expect(() => list[4] = 5, throwsRangeError);
        expect(() => list[-1] = 5, throwsRangeError);
      });

      test('element callbacks on replacement', () {
        final removed = <int>[];
        final added = <int>[];

        list = CircularList<int>(
          3,
          onElementRemoved: removed.add,
          onElementAdded: added.add,
        );

        // Fill the list
        list.addAll([1, 2, 3]);
        expect(added, equals([1, 2, 3]));
        expect(removed, isEmpty);

        // Replace an element
        list[1] = 10;
        expect(added, equals([1, 2, 3])); // Не должен вызываться при замене
        expect(removed, isEmpty);

        // Add new element that causes overflow
        list.add(4);
        expect(removed, equals([1]));
        expect(added, equals([1, 2, 3, 4]));
      });

      test('overflow behavior', () {
        list.addAll([1, 2, 3, 4, 5, 6, 7]);
        expect(list.toList(), equals([3, 4, 5, 6, 7]));
        expect(list.latest, equals(7));
        expect(list.oldest, equals(3));
        expect(list.isFull, isTrue);
        expect(list.hasSpace, isFalse);
      });

      test('element callbacks', () {
        final removed = <int>[];
        final added = <int>[];

        list = CircularList<int>(
          3,
          onElementRemoved: removed.add,
          onElementAdded: added.add,
        );

        list.addAll([1, 2, 3, 4]);
        expect(removed, equals([1]));
        expect(added, equals([1, 2, 3, 4]));
      });
    });

    group('numeric operations', () {
      setUp(() {
        list.addAll([1, 2, 3, 4, 5]);
      });

      test('average calculation', () {
        expect(list.average, equals(3.0));
      });

      test('sum calculation', () {
        expect(list.sum, equals(15));
      });

      test('min/max values', () {
        expect(list.min, equals(1));
        expect(list.max, equals(5));
      });

      test('moving average', () {
        expect(list.movingAverage(3), equals(4.0)); // (3 + 4 + 5) / 3
        expect(list.movingAverage(2), equals(4.5)); // (4 + 5) / 2
        expect(list.movingAverage(), equals(3.0)); // all elements
      });
    });

    group('error handling', () {
      test('invalid capacity', () {
        expect(
          () => CircularList<int>(1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('invalid index access', () {
        list.add(1);
        expect(() => list[-1], throwsRangeError);
        expect(() => list[1], throwsRangeError);
      });

      test('length modification', () {
        expect(
          () => list.length = 10,
          throwsUnsupportedError,
        );
      });
    });

    group('type safety', () {
      test('non-numeric type for numeric operations', () {
        final stringList = CircularList<String>(3)..add('test');
        expect(stringList.average, equals(0.0));
        expect(stringList.sum, equals(0));
        expect(() => stringList.max, throwsUnsupportedError);
        expect(() => stringList.min, throwsUnsupportedError);
      });
    });

    test('copyWith', () {
      list.addAll([1, 2, 3]);
      final copy = list.copyWith(capacity: 4);

      expect(copy.capacity, equals(4));
      expect(copy.toList(), equals([1, 2, 3]));

      list.add(4);
      expect(copy.toList(), isNot(equals(list.toList())));
    });
  });
}
