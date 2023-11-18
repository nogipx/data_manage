import 'package:test/test.dart';

import '_data/test_tree.dart';

void main() {
  test(
    'Do not change parents when add new edges',
    () {
      final sut = StringTreeTest.testEditableTree();

      expect(
        () {
          sut.addEdge(
            StringTreeTest.root1Box1,
            StringTreeTest.root2Box1Leaf1,
          );
          print(sut.graphString);
        },
        throwsException,
      );
    },
  );

  test(
    'Accept only unique node keys',
    () {
      final sut = StringTreeTest.testEditableTree();

      expect(
        () {
          sut.addNode(
            StringTreeTest.root2Box1Leaf1,
          );
          print(sut.graphString);
        },
        throwsException,
      );
    },
  );
}
