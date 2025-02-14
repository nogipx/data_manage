import 'package:test/test.dart';
import 'package:data_manage/src/graph/_index.dart';

void main() {
  group('Graph Traversal |', () {
    late Graph<String> graph;
    late Node root;
    late Node node1;
    late Node node2;
    late Node node3;
    late Node node4;

    /*
      Структура тестового графа:
           root
          /    \
        node1  node2
        /  \     
    node3  node4 
    */

    setUp(() {
      root = Node('root');
      node1 = Node('node1');
      node2 = Node('node2');
      node3 = Node('node3');
      node4 = Node('node4');

      graph = Graph<String>(root: root);
      graph.addEdge(root, node1);
      graph.addEdge(root, node2);
      graph.addEdge(node1, node3);
      graph.addEdge(node1, node4);
    });

    group('Depth-First Traversal |', () {
      test('visits_all_nodes_in_depth_first_order', () {
        final visited = <String>[];
        final visitOrder = <String, int>{};
        var index = 0;

        graph.visitDepth((node) {
          visited.add(node.key);
          visitOrder[node.key] = index++;
          return VisitResult.continueVisit;
        });

        expect(
          visited.toSet(),
          equals({'root', 'node1', 'node2', 'node3', 'node4'}),
          reason: 'Все узлы должны быть посещены',
        );

        expect(
          visitOrder['root']!,
          lessThan(visitOrder['node1']!),
          reason: 'Корень должен быть посещен до node1',
        );
        expect(
          visitOrder['root']!,
          lessThan(visitOrder['node2']!),
          reason: 'Корень должен быть посещен до node2',
        );
        expect(
          visitOrder['node1']!,
          lessThan(visitOrder['node3']!),
          reason: 'node1 должен быть посещен до node3',
        );
        expect(
          visitOrder['node1']!,
          lessThan(visitOrder['node4']!),
          reason: 'node1 должен быть посещен до node4',
        );
      });

      test('stops_traversal_when_specific_node_encountered', () {
        final visited = <String>[];

        graph.visitDepth((node) {
          visited.add(node.key);
          return node.key == 'node3' ? VisitResult.breakVisit : VisitResult.continueVisit;
        });

        expect(
          visited.length,
          lessThan(graph.nodes.length),
          reason: 'Обход должен остановиться до посещения всех узлов',
        );
        expect(
          visited.last,
          equals('node3'),
          reason: 'Последним посещенным узлом должен быть node3',
        );
      });

      test('Iterator returns valid tree traversal', () {
        final visited = <String>[];
        final parents = <String, String>{};
        final iterator = graph.depthIterator;

        while (iterator.moveNext()) {
          final node = iterator.current;
          visited.add(node.key);
          final parent = graph.getNodeParent(node);
          if (parent != null) {
            parents[node.key] = parent.key;
          }
        }

        expect(visited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}));

        for (final entry in parents.entries) {
          final parentVisitIndex = visited.indexOf(entry.value);
          final childVisitIndex = visited.indexOf(entry.key);
          expect(parentVisitIndex, lessThan(childVisitIndex),
              reason: 'Родитель ${entry.value} должен быть посещен до потомка ${entry.key}');
        }
      });
    });

    group('Breadth-First Traversal |', () {
      test('visits_nodes_level_by_level', () {
        final visitedByLevel = <int, List<String>>{};

        graph.visitBreadth((node) {
          final level = graph.getNodeLevel(node);
          visitedByLevel.putIfAbsent(level, () => []).add(node.key);
          return VisitResult.continueVisit;
        });

        expect(
          visitedByLevel[0],
          equals(['root']),
          reason: 'На уровне 0 должен быть только корень',
        );
        expect(
          visitedByLevel[1]!.toSet(),
          equals({'node1', 'node2'}),
          reason: 'На уровне 1 должны быть node1 и node2',
        );
        expect(
          visitedByLevel[2]!.toSet(),
          equals({'node3', 'node4'}),
          reason: 'На уровне 2 должны быть node3 и node4',
        );
      });

      test('maintains_level_order_with_early_stop', () {
        final visited = <String>[];
        final levels = <String, int>{};

        graph.visitBreadth((node) {
          visited.add(node.key);
          levels[node.key] = graph.getNodeLevel(node);
          return node.key == 'node2' ? VisitResult.breakVisit : VisitResult.continueVisit;
        });

        for (var i = 0; i < visited.length - 1; i++) {
          final currentLevel = levels[visited[i]]!;
          final nextLevel = levels[visited[i + 1]]!;
          expect(
            nextLevel,
            greaterThanOrEqualTo(currentLevel),
            reason: 'Каждый следующий узел должен быть на том же или более глубоком уровне',
          );
        }
      });
    });

    group('Level-Based Operations |', () {
      test('correctly_determines_node_levels', () {
        expect(
          graph.getNodeLevel(root),
          equals(0),
          reason: 'Корень должен быть на уровне 0',
        );
        expect(
          graph.getNodeLevel(node1),
          equals(1),
          reason: 'node1 должен быть на уровне 1',
        );
        expect(
          graph.getNodeLevel(node2),
          equals(1),
          reason: 'node2 должен быть на уровне 1',
        );
        expect(
          graph.getNodeLevel(node3),
          equals(2),
          reason: 'node3 должен быть на уровне 2',
        );
        expect(
          graph.getNodeLevel(node4),
          equals(2),
          reason: 'node4 должен быть на уровне 2',
        );
      });

      test('provides_accurate_depths_map', () {
        final depths = graph.getDepths();

        expect(depths[root], equals(0), reason: 'Глубина корня должна быть 0');
        expect(depths[node1], equals(1), reason: 'Глубина node1 должна быть 1');
        expect(depths[node2], equals(1), reason: 'Глубина node2 должна быть 1');
        expect(depths[node3], equals(2), reason: 'Глубина node3 должна быть 2');
        expect(depths[node4], equals(2), reason: 'Глубина node4 должна быть 2');
      });

      test('level_iterator_returns_nodes_by_levels', () {
        final levels = <Set<String>>{};
        final iterator = graph.levelIterator;
        while (iterator.moveNext()) {
          levels.add(iterator.current.map((n) => n.key).toSet());
        }

        expect(levels, [
          {'root'},
          {'node1', 'node2'},
          {'node3', 'node4'},
        ]);
      });
    });

    group('Path Finding |', () {
      test('get_path_to_node', () {
        final path = graph.getPathToNode(node3);
        expect(
          path.map((n) => n.key).toList(),
          equals(['node3', 'node1', 'root']),
        );
      });

      test('get_vertical_path_between_nodes', () {
        final path = graph.getVerticalPathBetweenNodes(node3, node4);
        expect(
          path.map((n) => n.key),
          containsAll(['node1', 'node3', 'node4']),
        );
      });

      test('get_full_vertical_path', () {
        final path = graph.getFullVerticalPath(node1);
        expect(
          path.map((n) => n.key),
          containsAll(['root', 'node1', 'node3', 'node4']),
        );
      });

      test('find_lowest_common_ancestor', () {
        final lca = graph.findLowestCommonAncestor(node3, node4);
        expect(lca, equals(node1));

        final lca2 = graph.findLowestCommonAncestor(node3, node2);
        expect(lca2, equals(root));
      });

      test('check_ancestor', () {
        expect(graph.isAncestor(ancestor: root, descendant: node3), isTrue);
        expect(graph.isAncestor(ancestor: node1, descendant: node3), isTrue);
        expect(graph.isAncestor(ancestor: node2, descendant: node3), isFalse);
      });
    });

    group('Graph Operations |', () {
      test('get_siblings', () {
        final siblings = graph.getSiblings(node3);
        expect(siblings, equals({node4}));
      });

      test('get_leaves', () {
        final leaves = graph.getLeaves();
        expect(leaves, equals({node3, node4, node2}));
      });

      test('select_root_creates_new_graph', () {
        final subgraph = graph.extractSubtree(node1.key);
        expect(subgraph.root, equals(node1));
        expect(subgraph.nodes.length, equals(3));
        expect(
          subgraph.nodes.keys,
          containsAll(['node1', 'node3', 'node4']),
        );

        expect(subgraph.getNodeEdges(node1), equals({node3, node4}));
      });

      test('extract_subtree_creates_new_graph', () {
        final subgraph = graph.extractSubtree(node1.key, copy: true);
        expect(subgraph.root, equals(node1));
        expect(subgraph.nodes.length, equals(3));
        expect(
          subgraph.nodes.keys,
          containsAll(['node1', 'node3', 'node4']),
        );

        expect(subgraph.getNodeEdges(node1), equals({node3, node4}));

        subgraph.removeNode(node3);
        expect(graph.containsNode(node3.key), isTrue);
      });

      test('extract_subtree_creates_view', () {
        final view = graph.extractSubtree(node1.key, copy: false);
        expect(view.root, equals(node1));
        expect(view.nodes.length, equals(3));
        expect(
          view.nodes.keys,
          containsAll(['node1', 'node3', 'node4']),
        );

        expect(view.getNodeEdges(node1), equals({node3, node4}));

        view.removeNode(node3);
        expect(graph.containsNode(node3.key), isFalse);
      });
    });

    group('Subtree Operations |', () {
      test('extract_subtree_from_root_returns_full_graph_copy', () {
        final subgraph = graph.extractSubtree(root.key, copy: true);

        expect(subgraph.root, equals(root));
        expect(subgraph.nodes.length, equals(graph.nodes.length));
        expect(
          subgraph.nodes.keys,
          containsAll(['root', 'node1', 'node2', 'node3', 'node4']),
        );

        subgraph.removeNode(node1);
        expect(graph.containsNode(node1.key), isTrue);
      });

      test('extract_subtree_with_node_data', () {
        graph.updateNodeData(node1.key, 'data1');
        graph.updateNodeData(node3.key, 'data3');

        final subgraph = graph.extractSubtree(node1.key, copy: true);

        expect(subgraph.getNodeData(node1.key), equals('data1'));
        expect(subgraph.getNodeData(node3.key), equals('data3'));
        expect(subgraph.getNodeData(node2.key), isNull);
      });

      test('extract_subtree_from_non_existent_node_throws_error', () {
        expect(
          () => graph.extractSubtree('non-existent'),
          throwsStateError,
        );
      });

      test('view_modifications_affect_original_graph', () {
        final view = graph.extractSubtree(node1.key, copy: false);
        final newNode = Node('new_node');

        view.addNode(newNode);
        view.addEdge(node3, newNode);

        expect(graph.containsNode(newNode.key), isTrue);
        expect(graph.getNodeParent(newNode), equals(node3));

        view.removeNode(node4);
        expect(graph.containsNode(node4.key), isFalse);
      });

      test('view_restricts_operations_outside_subtree', () {
        final view = graph.extractSubtree(node1.key, copy: false);

        expect(
          () => view.addEdge(node2, Node('new_node')),
          throwsStateError,
        );

        expect(view.getNodeData(node2.key), isNull);

        expect(view.nodes.length, equals(3));
        expect(view.containsNode(node2.key), isFalse);
      });

      test('nested_subtree_extraction', () {
        final subgraph = graph.extractSubtree(node1.key, copy: true);
        final nestedSubgraph = subgraph.extractSubtree(node3.key, copy: true);

        expect(nestedSubgraph.root, equals(node3));
        expect(nestedSubgraph.nodes.length, equals(1));
        expect(nestedSubgraph.edges.isEmpty, isTrue);
      });
    });

    test('graph_string_representation', () {
      graph.clear();

      final root = Node('root');
      final node1 = Node('node1');
      final node2 = Node('node2');
      final node3 = Node('node3');
      final node4 = Node('node4');

      graph.addNode(root);
      graph.addNode(node1);
      graph.addNode(node2);
      graph.addNode(node3);
      graph.addNode(node4);

      graph.addEdge(root, node1);
      graph.addEdge(root, node2);
      graph.addEdge(node1, node3);
      graph.addEdge(node1, node4);

      final graphString = graph.graphString;
      expect(graphString, contains('Node(root)'));
      expect(graphString, contains('|  Node(node1)'));
      expect(graphString, contains('|  |  Node(node3)'));
      expect(graphString, contains('|  |  Node(node4)'));
      expect(graphString, contains('|  Node(node2)'));
    });

    group('Empty and Single Node Graphs |', () {
      test('single_node_graph_traversal', () {
        final singleNodeGraph = Graph<String>(root: Node('single'));

        final depthVisited = <String>[];
        singleNodeGraph.visitDepth((node) {
          depthVisited.add(node.key);
          return VisitResult.continueVisit;
        });

        final breadthVisited = <String>[];
        singleNodeGraph.visitBreadth((node) {
          breadthVisited.add(node.key);
          return VisitResult.continueVisit;
        });

        expect(depthVisited, ['single']);
        expect(breadthVisited, ['single']);
      });

      test('empty_iterators_after_clear', () {
        graph.clear();

        expect(graph.nodes.length, equals(1));
        expect(graph.containsNode(root.key), isTrue);

        final depthVisited = <String>[];
        final breadthVisited = <String>[];
        final levelVisited = <Set<String>>[];

        final depthIterator = graph.depthIterator;
        while (depthIterator.moveNext()) {
          depthVisited.add(depthIterator.current.key);
        }
        expect(depthVisited, equals(['root']));

        final breadthIterator = graph.breadthIterator;
        while (breadthIterator.moveNext()) {
          breadthVisited.add(breadthIterator.current.key);
        }
        expect(breadthVisited, equals(['root']));

        final levelIterator = graph.levelIterator;
        while (levelIterator.moveNext()) {
          levelVisited.add(levelIterator.current.map((n) => n.key).toSet());
        }
        expect(
            levelVisited,
            equals([
              {'root'}
            ]));
      });
    });

    group('Complex Graph Structures |', () {
      test('diamond_shape_graph_traversal', () {
        final a = Node('A');
        final b = Node('B');
        final c = Node('C');
        final d = Node('D');

        final diamondGraph = Graph<String>(root: a);
        diamondGraph.addEdge(a, b);
        diamondGraph.addEdge(a, c);
        diamondGraph.addEdge(b, d);

        final visited = <String>[];
        diamondGraph.visitBreadth((node) {
          visited.add(node.key);
          return VisitResult.continueVisit;
        });

        final dIndex = visited.indexOf('D');
        final bIndex = visited.indexOf('B');
        final cIndex = visited.indexOf('C');

        expect(dIndex, greaterThan(bIndex));
        expect(dIndex, greaterThan(cIndex));
      });

      test('diamond_shape_throws_on_multiple_parents', () {
        // Arrange
        /*
             A
            / \
           B   C
            \ /
             D   <- Попытка добавить второго родителя должна вызвать ошибку
        */
        final a = Node('A');
        final b = Node('B');
        final c = Node('C');
        final d = Node('D');

        final diamondGraph = Graph<String>(root: a);
        diamondGraph.addEdge(a, b);
        diamondGraph.addEdge(a, c);
        diamondGraph.addEdge(b, d);

        // Act & Assert
        expect(
          () => diamondGraph.addEdge(c, d),
          throwsStateError,
          reason: 'Узел не может иметь более одного родителя',
        );
      });
    });

    group('Performance Tests |', () {
      test('depth_first_traversal_performance', () {
        // Arrange - создаем большой граф в виде дерева
        final root = Node('root');
        final graph = Graph<String>(root: root);

        var currentParent = root;
        for (var i = 0; i < 100; i++) {
          final level = List.generate(10, (j) => Node('node${i}_$j'));
          for (final node in level) {
            graph.addEdge(currentParent, node);
          }
          currentParent =
              level[0]; // Следующий уровень будет присоединен к первому узлу текущего уровня
        }

        // Act
        final startTime = DateTime.now();
        graph.visitDepth((node) => VisitResult.continueVisit);
        final duration = DateTime.now().difference(startTime);

        // Assert
        expect(
          duration.inMilliseconds,
          lessThan(500),
          reason: 'Обход в глубину должен быть эффективным даже на больших графах',
        );
      });

      test('breadth_first_traversal_performance', () {
        // Arrange - создаем широкий граф
        final root = Node('root');
        final children = List.generate(1000, (i) => Node('child$i'));
        final graph = Graph<String>(root: root);

        for (final child in children) {
          graph.addEdge(root, child);
        }

        // Act
        final startTime = DateTime.now();
        graph.visitBreadth((node) => VisitResult.continueVisit);
        final duration = DateTime.now().difference(startTime);

        // Assert
        expect(
          duration.inMilliseconds,
          lessThan(500),
          reason: 'Обход в ширину должен быть эффективным даже на широких графах',
        );
      });

      test('cache_effectiveness_for_repeated_operations', () {
        // Arrange - создаем дерево
        final root = Node('root');
        final graph = Graph<String>(root: root);

        var currentParent = root;
        for (var i = 0; i < 100; i++) {
          final node = Node('node$i');
          graph.addEdge(currentParent, node);
          currentParent = node;
        }

        // Act - первый вызов (заполнение кэша)
        final firstCallStart = DateTime.now();
        final depths1 = graph.getDepths();
        final firstCallDuration = DateTime.now().difference(firstCallStart);

        // Второй вызов (должен использовать кэш)
        final secondCallStart = DateTime.now();
        final depths2 = graph.getDepths();
        final secondCallDuration = DateTime.now().difference(secondCallStart);

        // Assert
        expect(
          secondCallDuration.inMicroseconds,
          lessThan(firstCallDuration.inMicroseconds),
          reason: 'Повторные операции должны быть быстрее благодаря кэшированию',
        );
      });
    });
  });
}
