import 'package:test/test.dart';

import '_data/test_tree.dart';

void main() {
  test(
    'String representation',
    () {
      final sut = StringTreeTest.testReadableTree();
      print(sut.graphString);
    },
  );

  test(
    'Leaves from root',
    () {
      final sut = StringTreeTest.testReadableTree();
      final leaves = sut.getLeaves();
      expect(
        leaves,
        equals({
          StringTreeTest.root1Box1Leaf1,
          StringTreeTest.root1Box1Leaf2,
          StringTreeTest.root1Box1Leaf3,
          StringTreeTest.root2Box1Leaf1,
        }),
      );
    },
  );

  test(
    'Leaves from root-1',
    () {
      final sut = StringTreeTest.testReadableTree();
      final leaves = sut.getLeaves(startNode: StringTreeTest.root1);
      expect(
        leaves,
        equals({
          StringTreeTest.root1Box1Leaf1,
          StringTreeTest.root1Box1Leaf2,
          StringTreeTest.root1Box1Leaf3,
        }),
      );
    },
  );

  test(
    'Leaves from root-2',
    () {
      final sut = StringTreeTest.testReadableTree();
      final leaves = sut.getLeaves(startNode: StringTreeTest.root2);
      expect(
        leaves,
        equals({
          StringTreeTest.root2Box1Leaf1,
        }),
      );
    },
  );
}
