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
        /  \      \
    node3  node4  node5
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
      test('Visit all nodes', () {
        final visited = <String>[];
        final visitOrder = <String, int>{};
        var index = 0;

        graph.visitDepth((node) {
          visited.add(node.key);
          visitOrder[node.key] = index++;
          return VisitResult.continueVisit;
        });

        // Проверяем, что все узлы были посещены
        expect(visited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}));

        // Проверяем инварианты обхода в глубину:
        // 1. Родитель должен быть посещен до своих детей
        expect(visitOrder['root']!, lessThan(visitOrder['node1']!));
        expect(visitOrder['root']!, lessThan(visitOrder['node2']!));
        expect(visitOrder['node1']!, lessThan(visitOrder['node3']!));
        expect(visitOrder['node1']!, lessThan(visitOrder['node4']!));

        // 2. Все узлы одной ветви должны быть посещены до перехода к другой
        final node1Subtree = {visitOrder['node1']!, visitOrder['node3']!, visitOrder['node4']!};
        final node2Subtree = {visitOrder['node2']!};

        // Проверяем, что либо все узлы поддерева node1 идут до node2,
        // либо все после - но не вперемешку
        final allNode1BeforeNode2 = node1Subtree.every((i) => i < visitOrder['node2']!);
        final allNode1AfterNode2 = node1Subtree.every((i) => i > visitOrder['node2']!);
        expect(allNode1BeforeNode2 || allNode1AfterNode2, isTrue);
      });

      test('Break visit', () {
        final visited = <String>[];
        final parents = <String>{};

        graph.visitDepth((node) {
          visited.add(node.key);
          final parent = graph.getNodeParent(node);
          if (parent != null) parents.add(parent.key);

          return node.key == 'node3' ? VisitResult.breakVisit : VisitResult.continueVisit;
        });

        // Проверяем, что мы посетили только часть графа
        expect(visited.length, lessThan(graph.nodes.length));

        // Проверяем, что все посещенные узлы образуют валидный путь
        for (final nodeKey in visited.where((k) => k != 'root')) {
          expect(parents, contains(graph.getNodeParent(Node(nodeKey))?.key));
        }
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

        // Проверяем, что все узлы были посещены
        expect(visited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}));

        // Проверяем корректность связей родитель-потомок
        for (final entry in parents.entries) {
          final parentVisitIndex = visited.indexOf(entry.value);
          final childVisitIndex = visited.indexOf(entry.key);
          expect(parentVisitIndex, lessThan(childVisitIndex),
              reason: 'Родитель ${entry.value} должен быть посещен до потомка ${entry.key}');
        }
      });
    });

    group('Breadth-First Traversal |', () {
      test('Visit all nodes with level order', () {
        final visited = <String>[];
        final levels = <String, int>{};

        graph.visitBreadth((node) {
          visited.add(node.key);
          levels[node.key] = graph.getNodeLevel(node);
          return VisitResult.continueVisit;
        });

        // Проверяем, что все узлы были посещены
        expect(visited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}));

        // Проверяем инварианты обхода в ширину:
        // 1. Узлы на одном уровне должны быть посещены до узлов следующего уровня
        for (var i = 0; i < visited.length - 1; i++) {
          final currentLevel = levels[visited[i]]!;
          final nextLevel = levels[visited[i + 1]]!;
          expect(nextLevel, greaterThanOrEqualTo(currentLevel),
              reason:
                  'Узел ${visited[i + 1]} уровня $nextLevel посещен после узла ${visited[i]} уровня $currentLevel');
        }
      });

      test('Break visit preserves level order', () {
        final visited = <String>[];
        final levels = <String, int>{};

        graph.visitBreadth((node) {
          visited.add(node.key);
          levels[node.key] = graph.getNodeLevel(node);
          return node.key == 'node2' ? VisitResult.breakVisit : VisitResult.continueVisit;
        });

        // Проверяем порядок уровней до точки остановки
        var previousLevel = -1;
        for (final nodeKey in visited) {
          final currentLevel = levels[nodeKey]!;
          expect(currentLevel, greaterThanOrEqualTo(previousLevel));
          previousLevel = currentLevel;
        }
      });

      test('Iterator maintains breadth-first properties', () {
        final visited = <String>[];
        final levels = <String, int>{};
        final iterator = graph.breadthIterator;

        while (iterator.moveNext()) {
          final node = iterator.current;
          visited.add(node.key);
          levels[node.key] = graph.getNodeLevel(node);
        }

        // Проверяем, что все узлы были посещены
        expect(visited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}));

        // Проверяем, что узлы на каждом уровне сгруппированы вместе
        final levelGroups = <int, List<String>>{};
        for (final entry in levels.entries) {
          levelGroups.putIfAbsent(entry.value, () => []).add(entry.key);
        }

        // Проверяем, что узлы каждого уровня идут последовательно
        for (final levelNodes in levelGroups.values) {
          final indices = levelNodes.map((node) => visited.indexOf(node)).toList();
          indices.sort();
          // Проверяем, что индексы последовательны (нет разрывов)
          for (var i = 1; i < indices.length; i++) {
            expect(indices[i] - indices[i - 1], equals(1),
                reason: 'Узлы одного уровня должны быть посещены последовательно');
          }
        }
      });
    });

    group('Level Traversal |', () {
      test('Get node level', () {
        expect(graph.getNodeLevel(root), equals(0));
        expect(graph.getNodeLevel(node1), equals(1));
        expect(graph.getNodeLevel(node3), equals(2));
      });

      test('Get depths map', () {
        final depths = graph.getDepths();
        expect(depths[root], equals(0));
        expect(depths[node1], equals(1));
        expect(depths[node2], equals(1));
        expect(depths[node3], equals(2));
        expect(depths[node4], equals(2));
      });

      test('Level iterator returns nodes by levels', () {
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
      test('Get path to node', () {
        final path = graph.getPathToNode(node3);
        expect(
          path.map((n) => n.key).toList(),
          equals(['node3', 'node1', 'root']),
        );
      });

      test('Get vertical path between nodes', () {
        final path = graph.getVerticalPathBetweenNodes(node3, node4);
        expect(
          path.map((n) => n.key),
          containsAll(['node1', 'node3', 'node4']),
        );
      });

      test('Get full vertical path', () {
        final path = graph.getFullVerticalPath(node1);
        expect(
          path.map((n) => n.key),
          containsAll(['root', 'node1', 'node3', 'node4']),
        );
      });

      test('Find lowest common ancestor', () {
        final lca = graph.findLowestCommonAncestor(node3, node4);
        expect(lca, equals(node1));

        final lca2 = graph.findLowestCommonAncestor(node3, node2);
        expect(lca2, equals(root));
      });

      test('Check ancestor', () {
        expect(graph.isAncestor(ancestor: root, descendant: node3), isTrue);
        expect(graph.isAncestor(ancestor: node1, descendant: node3), isTrue);
        expect(graph.isAncestor(ancestor: node2, descendant: node3), isFalse);
      });
    });

    group('Graph Operations |', () {
      test('Get siblings', () {
        final siblings = graph.getSiblings(node3);
        expect(siblings, equals({node4}));
      });

      test('Get leaves', () {
        final leaves = graph.getLeaves();
        expect(leaves, equals({node3, node4, node2}));
      });

      test('Select root creates new graph', () {
        final subgraph = graph.extractSubtree(node1.key);
        expect(subgraph.root, equals(node1));
        expect(subgraph.nodes.length, equals(3));
        expect(
          subgraph.nodes.keys,
          containsAll(['node1', 'node3', 'node4']),
        );

        // Проверяем, что ребра сохранились
        expect(subgraph.getNodeEdges(node1), equals({node3, node4}));
      });

      test('Extract subtree creates new graph', () {
        final subgraph = graph.extractSubtree(node1.key, copy: true);
        expect(subgraph.root, equals(node1));
        expect(subgraph.nodes.length, equals(3));
        expect(
          subgraph.nodes.keys,
          containsAll(['node1', 'node3', 'node4']),
        );

        // Проверяем, что ребра сохранились
        expect(subgraph.getNodeEdges(node1), equals({node3, node4}));

        // Проверяем, что это действительно копия
        subgraph.removeNode(node3);
        expect(graph.containsNode(node3.key), isTrue);
      });

      test('Extract subtree creates view', () {
        final view = graph.extractSubtree(node1.key, copy: false);
        expect(view.root, equals(node1));
        expect(view.nodes.length, equals(3));
        expect(
          view.nodes.keys,
          containsAll(['node1', 'node3', 'node4']),
        );

        // Проверяем, что ребра сохранились
        expect(view.getNodeEdges(node1), equals({node3, node4}));

        // Проверяем, что это view на оригинальный граф
        view.removeNode(node3);
        expect(graph.containsNode(node3.key), isFalse);
      });
    });

    test('Graph string representation', () {
      // Очищаем граф перед тестом
      graph.clear();

      // Сетапим граф заново
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
  });
}
