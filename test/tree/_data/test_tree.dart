import 'package:data_manage/data_manage.dart';

abstract class StringTreeTest {
  static const root = Node('root');
  static const root1 = Node('root-1');
  static const root1Box1 = Node('root-1_box-1');
  static const root1Box1Leaf1 = Node('root-1_box-1_leaf-1');
  static const root1Box1Leaf2 = Node('root-1_box-1_leaf-2');
  static const root1Box1Leaf3 = Node('root-1_box-1_leaf-3');

  static const root2 = Node('root-2');
  static const root2Box1 = Node('root-2_box-1');
  static const root2Box1Leaf1 = Node('root-2_box-1_leaf-1');

  static IGraphEditable<String> _create() {
    final tree = Graph<String>(root: root);
    tree
          ..addEdge(root, root1)
          ..addEdge(root1, root1Box1)
          ..addEdge(root1Box1, root1Box1Leaf1)
          ..addEdge(root1Box1, root1Box1Leaf2)
          ..addEdge(root1Box1, root1Box1Leaf3)
        //
        ;

    tree
          ..addEdge(root, root2)
          ..addEdge(root2, root2Box1)
          ..addEdge(root2Box1, root2Box1Leaf1)
        //
        ;

    return tree;
  }

  static IGraph<String> testReadableTree() => _create();
  static IGraphEditable<String> testEditableTree() => _create();
}
