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

      test('depth_iterator_correctly_terminates_after_complete_traversal', () {
        final iterator = graph.depthIterator;

        // Проходим все узлы
        var nodesCount = 0;
        while (iterator.moveNext()) {
          nodesCount++;
        }
        expect(nodesCount, equals(5), reason: 'Должно быть ровно 5 узлов в тестовом графе');

        // Проверяем что после полного обхода итератор корректно завершается
        expect(iterator.moveNext(), isFalse,
            reason: 'После полного обхода moveNext() должен возвращать false');
        expect(iterator.moveNext(), isFalse,
            reason: 'Повторный вызов moveNext() тоже должен возвращать false');
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

      test('breadth_iterator_correctly_terminates_after_complete_traversal', () {
        final iterator = graph.breadthIterator;

        // Проходим все узлы
        var nodesCount = 0;
        while (iterator.moveNext()) {
          nodesCount++;
        }
        expect(nodesCount, equals(5), reason: 'Должно быть ровно 5 узлов в тестовом графе');

        // Проверяем что после полного обхода итератор корректно завершается
        expect(iterator.moveNext(), isFalse,
            reason: 'После полного обхода moveNext() должен возвращать false');
        expect(iterator.moveNext(), isFalse,
            reason: 'Повторный вызов moveNext() тоже должен возвращать false');
      });
    });

    group('Level-Based Operations |', () {
      test('correctly calculates node levels', () {
        expect(graph.getNodeLevel(root), equals(0), reason: 'Корень должен быть на уровне 0');
        expect(graph.getNodeLevel(node1), equals(1),
            reason: 'Прямые потомки корня должны быть на уровне 1');
        expect(graph.getNodeLevel(node2), equals(1),
            reason: 'Все узлы одного уровня должны иметь одинаковую глубину');
        expect(graph.getNodeLevel(node3), equals(2),
            reason: 'Потомки узлов первого уровня должны быть на уровне 2');
        expect(graph.getNodeLevel(node4), equals(2),
            reason: 'Узлы одного родителя должны быть на одном уровне');
      });

      test('depth map matches node levels', () {
        final depths = graph.getDepths();
        final expectedDepths = {
          root: 0,
          node1: 1,
          node2: 1,
          node3: 2,
          node4: 2,
        };

        expect(depths, equals(expectedDepths),
            reason: 'Карта глубин должна соответствовать уровням узлов в графе');

        // Проверяем согласованность с getNodeLevel
        for (final node in graph.nodes.values) {
          expect(depths[node], equals(graph.getNodeLevel(node)),
              reason: 'Глубина узла должна совпадать с его уровнем');
        }
      });

      test('level iterator groups nodes by their levels', () {
        final levels = <Set<String>>[];
        final iterator = graph.levelIterator;
        final nodesByLevel = <int, Set<Node>>{};

        // Собираем узлы по уровням через итератор
        while (iterator.moveNext()) {
          levels.add(iterator.current.map((n) => n.key).toSet());
        }

        // Собираем узлы по уровням через getNodeLevel
        for (final node in graph.nodes.values) {
          final level = graph.getNodeLevel(node);
          nodesByLevel.putIfAbsent(level, () => {}).add(node);
        }

        // Проверяем что группировка итератора совпадает с прямым расчетом уровней
        var levelIndex = 0;
        for (final levelNodes in nodesByLevel.values) {
          expect(levels[levelIndex], equals(levelNodes.map((n) => n.key).toSet()),
              reason: 'Группировка узлов итератором должна совпадать с их уровнями');
          levelIndex++;
        }

        // Проверяем порядок уровней
        expect(
            levels,
            equals([
              {'root'},
              {'node1', 'node2'},
              {'node3', 'node4'},
            ]),
            reason: 'Узлы должны быть сгруппированы по уровням в правильном порядке');
      });

      test('level iterator correctly terminates after complete traversal', () {
        final iterator = graph.levelIterator;
        var levelsCount = 0;

        // Проходим все уровни
        while (iterator.moveNext()) {
          levelsCount++;
        }

        expect(levelsCount, equals(3), reason: 'В тестовом графе должно быть ровно 3 уровня');

        // Проверяем корректное завершение
        expect(iterator.moveNext(), isFalse,
            reason: 'После полного обхода moveNext() должен возвращать false');
        expect(iterator.moveNext(), isFalse,
            reason: 'Повторный вызов moveNext() тоже должен возвращать false');
      });
    });

    group('Path Finding |', () {
      test('path operations work correctly', () {
        // Тест get_path_to_node
        final pathToNode = graph.getPathToNode(node3);
        expect(
          pathToNode.map((n) => n.key).toList(),
          equals(['node3', 'node1', 'root']),
          reason: 'Путь до узла должен быть корректным',
        );

        // Тест get_vertical_path_between_nodes
        final verticalPath = graph.getVerticalPathBetweenNodes(node3, node4);
        expect(
          verticalPath.map((n) => n.key),
          containsAll(['node1', 'node3', 'node4']),
          reason: 'Вертикальный путь между узлами должен быть корректным',
        );

        // Тест get_full_vertical_path
        final fullPath = graph.getFullVerticalPath(node1);
        expect(
          fullPath.map((n) => n.key),
          containsAll(['root', 'node1', 'node3', 'node4']),
          reason: 'Полный вертикальный путь должен содержать все узлы',
        );
      });

      test('ancestor operations work correctly', () {
        // Тест lowest common ancestor
        final lca = graph.findLowestCommonAncestor(node3, node4);
        expect(lca, equals(node1),
            reason: 'Ближайший общий предок node3 и node4 должен быть node1');

        final lca2 = graph.findLowestCommonAncestor(node3, node2);
        expect(lca2, equals(root), reason: 'Ближайший общий предок node3 и node2 должен быть root');

        // Тест проверки предка
        expect(graph.isAncestor(ancestor: root, descendant: node3), isTrue,
            reason: 'root должен быть предком node3');
        expect(graph.isAncestor(ancestor: node1, descendant: node3), isTrue,
            reason: 'node1 должен быть предком node3');
        expect(graph.isAncestor(ancestor: node2, descendant: node3), isFalse,
            reason: 'node2 не должен быть предком node3');
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

    group('Iterator Behavior |', () {
      test('all_iterators_complete_correctly', () {
        final iterators = {
          'depth': graph.depthIterator,
          'breadth': graph.breadthIterator,
          'level': graph.levelIterator,
          'leaves': graph.leavesIterator,
        };

        for (final entry in iterators.entries) {
          final name = entry.key;
          final iterator = entry.value;

          // Проверяем что итератор возвращает данные
          var hasElements = false;
          while (iterator.moveNext()) {
            hasElements = true;
          }
          expect(hasElements, isTrue, reason: '$name итератор должен вернуть хотя бы один элемент');

          // Проверяем корректное завершение
          expect(iterator.moveNext(), isFalse,
              reason: '$name итератор должен корректно завершиться');
          expect(iterator.moveNext(), isFalse,
              reason: '$name итератор не должен возобновить работу после завершения');
        }
      });

      test('iterators_return_expected_elements', () {
        // DFS
        final depthVisited = <String>[];
        final depthIterator = graph.depthIterator;
        while (depthIterator.moveNext()) {
          depthVisited.add(depthIterator.current.key);
        }
        expect(depthVisited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}),
            reason: 'DFS должен посетить все узлы');

        // BFS
        final breadthVisited = <String>[];
        final breadthIterator = graph.breadthIterator;
        while (breadthIterator.moveNext()) {
          breadthVisited.add(breadthIterator.current.key);
        }
        expect(breadthVisited.toSet(), equals({'root', 'node1', 'node2', 'node3', 'node4'}),
            reason: 'BFS должен посетить все узлы');

        // Level
        final levelVisited = <Set<String>>[];
        final levelIterator = graph.levelIterator;
        while (levelIterator.moveNext()) {
          levelVisited.add(levelIterator.current.map((n) => n.key).toSet());
        }
        expect(
            levelVisited,
            equals([
              {'root'},
              {'node1', 'node2'},
              {'node3', 'node4'}
            ]),
            reason: 'Level итератор должен группировать узлы по уровням');

        // Leaves
        final leavesVisited = <String>{};
        final leavesIterator = graph.leavesIterator;
        while (leavesIterator.moveNext()) {
          leavesVisited.add(leavesIterator.current.key);
        }
        expect(leavesVisited, equals({'node2', 'node3', 'node4'}),
            reason: 'Leaves итератор должен вернуть только листья');
      });

      test('new_iterator_starts_fresh', () {
        for (final iterator in [
          () => graph.depthIterator,
          () => graph.breadthIterator,
          () => graph.levelIterator,
          () => graph.leavesIterator,
        ]) {
          // Первый проход
          final firstRun = <dynamic>[];
          var it = iterator();
          while (it.moveNext()) {
            firstRun.add(it.current);
          }
          expect(firstRun, isNotEmpty);

          // Второй проход с новым итератором
          final secondRun = <dynamic>[];
          it = iterator();
          while (it.moveNext()) {
            secondRun.add(it.current);
          }
          expect(secondRun, equals(firstRun),
              reason: 'Новый итератор должен вернуть те же элементы в том же порядке');
        }
      });
    });

    group('Edge Cases and Special Structures |', () {
      group('Empty and Single Node Graphs |', () {
        test('empty_graph_contains_only_root', () {
          graph.clear();

          expect(graph.nodes.length, equals(1), reason: 'После clear должен остаться только root');
          expect(graph.containsNode(root.key), isTrue,
              reason: 'Root должен сохраниться после clear');
          expect(graph.edges.isEmpty, isTrue, reason: 'В пустом графе не должно быть рёбер');
          expect(graph.parents.isEmpty, isTrue,
              reason: 'В пустом графе не должно быть связей родитель-потомок');
        });

        test('empty_graph_traversal', () {
          graph.clear();

          // Проверяем все типы обхода на пустом графе
          final traversals = {
            'DFS': () => graph.visitDepth((node) => VisitResult.continueVisit),
            'BFS': () => graph.visitBreadth((node) => VisitResult.continueVisit),
            'Level': () => graph.levelIterator,
            'Leaves': () => graph.leavesIterator,
          };

          for (final entry in traversals.entries) {
            final name = entry.key;
            final visited = <String>[];

            if (name == 'Level') {
              final levelIterator = entry.value() as Iterator<Set<Node>>;
              var levelCount = 0;
              while (levelIterator.moveNext()) {
                levelCount++;
                visited.addAll(levelIterator.current.map((n) => n.key));
              }
              expect(levelCount, equals(1),
                  reason: '$name должен найти только один уровень в пустом графе');
            } else if (name == 'Leaves') {
              final leavesIterator = entry.value() as Iterator<Node>;
              while (leavesIterator.moveNext()) {
                visited.add(leavesIterator.current.key);
              }
            } else {
              graph.visitDepth((node) {
                visited.add(node.key);
                return VisitResult.continueVisit;
              });
            }

            expect(visited, equals(['root']),
                reason: '$name должен найти только root в пустом графе');
          }
        });

        test('single_node_operations', () {
          final singleNodeGraph = Graph<String>(root: Node('single'));

          expect(singleNodeGraph.getNodeLevel(singleNodeGraph.root), equals(0),
              reason: 'Уровень единственного узла должен быть 0');
          expect(singleNodeGraph.getLeaves(), equals({singleNodeGraph.root}),
              reason: 'Единственный узел должен быть листом');
          expect(singleNodeGraph.getDepths(), equals({singleNodeGraph.root: 0}),
              reason: 'Глубина единственного узла должна быть 0');
          expect(singleNodeGraph.edges.isEmpty, isTrue,
              reason: 'У графа с одним узлом не должно быть рёбер');
        });
      });

      group('Special Graph Structures |', () {
        test('diamond_shape_structure', () {
          // Arrange
          /*
               A
              / \
             B   C
              \ /
               D
          */
          final a = Node('A');
          final b = Node('B');
          final c = Node('C');
          final d = Node('D');

          final diamondGraph = Graph<String>(root: a);
          diamondGraph.addEdge(a, b);
          diamondGraph.addEdge(a, c);
          diamondGraph.addEdge(b, d);

          // Проверяем корректность структуры
          expect(diamondGraph.getNodeLevel(d), equals(2), reason: 'Узел D должен быть на уровне 2');
          expect(diamondGraph.getNodeParent(d), equals(b), reason: 'Родителем D должен быть B');

          // Проверяем запрет множественных родителей
          expect(
            () => diamondGraph.addEdge(c, d),
            throwsStateError,
            reason: 'Узел не может иметь более одного родителя',
          );
        });

        test('deep_chain_structure', () {
          // Создаем цепочку узлов
          var current = root;
          for (var i = 0; i < 10; i++) {
            final next = Node('chain$i');
            graph.addEdge(current, next);
            current = next;
          }

          // Проверяем глубину
          expect(graph.getNodeLevel(current), equals(10),
              reason: 'Последний узел должен быть на уровне 10');

          // Проверяем что все промежуточные узлы имеют ровно одного потомка
          for (var i = 0; i < 9; i++) {
            final node = graph.getNodeByKey('chain$i');
            expect(graph.getNodeEdges(node!).length, equals(1),
                reason: 'Промежуточный узел должен иметь ровно одного потомка');
          }
        });

        test('wide_level_structure', () {
          // Создаем новый граф для чистоты теста
          final wideRoot = Node('wide_root');
          final wideGraph = Graph<String>(root: wideRoot);

          // Создаем структуру с широким уровнем (много потомков у одного узла)
          for (var i = 0; i < 100; i++) {
            wideGraph.addEdge(wideRoot, Node('wide$i'));
          }

          expect(wideGraph.getNodeEdges(wideRoot).length, equals(100),
              reason: 'Root должен иметь 100 потомков');

          final levelNodes = wideGraph.levelIterator;
          levelNodes.moveNext(); // root level
          levelNodes.moveNext(); // wide level
          expect(levelNodes.current.length, equals(100),
              reason: 'Широкий уровень должен содержать 100 узлов');

          // Проверяем что все узлы на одном уровне
          for (final node in levelNodes.current) {
            expect(wideGraph.getNodeLevel(node), equals(1),
                reason: 'Все узлы должны быть на уровне 1');
          }
        });
      });
    });

    group('Performance and Complexity |', () {
      Graph<String> createGraphOfSize(int size) {
        final root = Node('root');
        final graph = Graph<String>(root: root);

        var currentParent = root;
        for (var i = 0; i < size; i++) {
          final node = Node('node$i');
          graph.addEdge(currentParent, node);
          // Каждый 10-й узел становится родителем для следующих узлов
          if (i % 10 == 0) currentParent = node;
        }
        return graph;
      }

      test('traversal_visits_each_node_exactly_once', () {
        final sizes = [10, 100, 1000];

        for (final size in sizes) {
          final graph = createGraphOfSize(size);
          final visitedNodes = <String>{};

          // DFS
          graph.visitDepth((node) {
            expect(visitedNodes.add(node.key), isTrue,
                reason: 'DFS должен посетить каждый узел только один раз');
            return VisitResult.continueVisit;
          });
          expect(visitedNodes.length, equals(size + 1), // +1 для root
              reason: 'DFS должен посетить все узлы');

          visitedNodes.clear();

          // BFS
          graph.visitBreadth((node) {
            expect(visitedNodes.add(node.key), isTrue,
                reason: 'BFS должен посетить каждый узел только один раз');
            return VisitResult.continueVisit;
          });
          expect(visitedNodes.length, equals(size + 1), // +1 для root
              reason: 'BFS должен посетить все узлы');
        }
      });

      test('node_operations_complexity', () {
        final sizes = [10, 100, 1000];

        for (final size in sizes) {
          final graph = createGraphOfSize(size);
          final operationCounts = <String, int>{};

          // Подсчет операций поиска
          var searchCount = 0;
          graph.visitDepth((node) {
            searchCount++;
            graph.containsNode(node.key);
            return VisitResult.continueVisit;
          });

          operationCounts['search'] = searchCount;

          // Проверяем что количество операций линейно
          expect(searchCount, equals(size + 1),
              reason: 'Количество операций поиска должно быть линейным');

          // Подсчет операций получения уровня
          var levelCount = 0;
          graph.visitDepth((node) {
            levelCount++;
            graph.getNodeLevel(node);
            return VisitResult.continueVisit;
          });

          operationCounts['level'] = levelCount;
          expect(levelCount, equals(size + 1),
              reason: 'Количество операций получения уровня должно быть линейным');
        }
      });

      test('memory_structure_size', () {
        final sizes = [10, 100, 1000];

        for (final size in sizes) {
          final graph = createGraphOfSize(size);

          // Проверяем основные структуры данных
          expect(graph.nodes.length, equals(size + 1),
              reason: 'Количество узлов должно соответствовать размеру');

          // В нашей структуре каждый узел кроме root имеет ровно одного родителя
          expect(graph.parents.length, equals(size),
              reason: 'Количество связей родитель-потомок должно быть size');

          // Проверяем что все структуры данных имеют ожидаемый размер
          expect(graph.edges.length, lessThanOrEqualTo(size + 1),
              reason: 'Количество рёбер не должно превышать size + 1');
        }
      });
    });

    group('Leaves Traversal |', () {
      test('leaves_iterator_correctly_terminates_after_complete_traversal', () {
        final iterator = graph.leavesIterator;

        // Проходим все листья
        final leaves = <String>{};
        while (iterator.moveNext()) {
          leaves.add(iterator.current.key);
        }

        expect(leaves, equals({'node2', 'node3', 'node4'}),
            reason: 'Должны быть найдены все листовые узлы');

        // Проверяем что после полного обхода итератор корректно завершается
        expect(iterator.moveNext(), isFalse,
            reason: 'После полного обхода moveNext() должен возвращать false');
        expect(iterator.moveNext(), isFalse,
            reason: 'Повторный вызов moveNext() тоже должен возвращать false');
      });
    });
  });
}
