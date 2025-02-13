import 'package:test/test.dart';
import 'package:data_manage/src/graph/_index.dart';

void main() {
  group('Graph Base Operations |', () {
    late Graph<String> graph;
    late Node root;

    setUp(() {
      root = Node('root');
      graph = Graph<String>(root: root);
    });

    test('Initial state is correct', () {
      expect(graph.nodes.length, equals(1));
      expect(graph.nodes.containsKey(root.key), isTrue);
      expect(graph.edges.isEmpty, isTrue);
      expect(graph.parents.isEmpty, isTrue);
      expect(graph.nodeData.isEmpty, isTrue);
    });

    group('Node Operations |', () {
      test('Add node', () {
        final node = Node('node1');
        graph.addNode(node);

        expect(graph.nodes.length, equals(2));
        expect(graph.containsNode(node.key), isTrue);
        expect(graph.getNodeByKey(node.key), equals(node));
      });

      test('Add duplicate node throws error', () {
        final node = Node('node1');
        graph.addNode(node);

        expect(
          () => graph.addNode(node),
          throwsStateError,
        );
      });

      test('Remove node', () {
        final node = Node('node1');
        graph.addNode(node);
        graph.removeNode(node);

        expect(graph.nodes.length, equals(1));
        expect(graph.containsNode(node.key), isFalse);
      });

      test('Remove non-existent node throws error', () {
        final node = Node('node1');
        expect(
          () => graph.removeNode(node),
          throwsStateError,
        );
      });
    });

    group('Edge Operations |', () {
      late Node parent;
      late Node child;

      setUp(() {
        parent = Node('parent');
        child = Node('child');
      });

      test('Add edge', () {
        graph.addEdge(parent, child);

        expect(graph.nodes.length, equals(3)); // root + parent + child
        expect(graph.edges[parent], contains(child));
        expect(graph.parents[child], equals(parent));
      });

      test('Add edge with existing nodes', () {
        graph.addNode(parent);
        graph.addNode(child);
        graph.addEdge(parent, child);

        expect(graph.nodes.length, equals(3));
        expect(graph.edges[parent], contains(child));
        expect(graph.parents[child], equals(parent));
      });

      test('Add edge to node with existing parent throws error', () {
        final parent1 = Node('parent1');
        final parent2 = Node('parent2');
        final child = Node('child');

        graph.addEdge(parent1, child);

        expect(
          () => graph.addEdge(parent2, child),
          throwsStateError,
        );

        expect(graph.getNodeParent(child), equals(parent1));
        expect(graph.getNodeEdges(parent1), contains(child));
        expect(graph.getNodeEdges(parent2).contains(child), isFalse);
      });

      test('Remove edge', () {
        graph.addEdge(parent, child);
        graph.removeEdge(parent, child);

        expect(graph.edges[parent]?.isEmpty ?? true, isTrue);
        expect(graph.parents[child], isNull);
      });

      test('Remove non-existent edge throws error', () {
        expect(
          () => graph.removeEdge(parent, child),
          throwsStateError,
        );
      });
    });

    test('Clear graph', () {
      final node1 = Node('node1');
      final node2 = Node('node2');
      graph.addEdge(node1, node2);
      graph.updateNodeData(node1.key, 'data1');

      graph.clear();

      expect(graph.nodes.isEmpty, isTrue);
      expect(graph.edges.isEmpty, isTrue);
      expect(graph.parents.isEmpty, isTrue);
      expect(graph.nodeData.isEmpty, isTrue);
    });
  });

  group('Node Data Operations |', () {
    late Graph<String> graph;
    late Node root;
    late Node node;

    setUp(() {
      root = Node('root');
      node = Node('node1');
      graph = Graph<String>(root: root);
      graph.addNode(node);
    });

    test('Update node data', () {
      graph.updateNodeData(node.key, 'data1');

      expect(graph.getNodeData(node.key), equals('data1'));
      expect(graph.nodeData[node.key], equals('data1'));
    });

    test('Update data for non-existent node throws error', () {
      expect(
        () => graph.updateNodeData('non-existent', 'data'),
        throwsStateError,
      );
    });

    test('Remove node also removes its data', () {
      graph.updateNodeData(node.key, 'data1');
      graph.removeNode(node);

      expect(graph.nodeData[node.key], isNull);
    });

    test('Clear graph also clears node data', () {
      graph.updateNodeData(node.key, 'data1');
      graph.clear();

      expect(graph.nodeData.isEmpty, isTrue);
    });
  });
}
