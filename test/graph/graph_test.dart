import 'package:test/test.dart';
import 'package:data_manage/src/graph/_index.dart';

void main() {
  late Graph<String> graph;
  late Node root;

  setUp(() {
    root = Node('root');
    graph = Graph<String>(root: root);
  });

  group('Graph Base Operations |', () {
    group('Initial State |', () {
      test('graph_starts_with_only_root_node', () {
        // Assert
        expect(
          graph.containsNode(root.key),
          isTrue,
          reason: 'Граф должен содержать корневой узел',
        );
        expect(
          graph.getNodeByKey(root.key),
          equals(root),
          reason: 'Должен возвращаться корректный корневой узел',
        );
      });

      test('root_node_is_isolated_without_edges', () {
        // Assert
        expect(
          graph.getNodeEdges(root),
          isEmpty,
          reason: 'У корневого узла не должно быть ребер',
        );
      });

      test('root_node_is_independent_without_parent', () {
        // Assert
        expect(
          graph.getNodeParent(root),
          isNull,
          reason: 'У корневого узла не должно быть родителя',
        );
      });

      test('root_node_starts_without_data', () {
        // Assert
        expect(
          graph.getNodeData(root.key),
          isNull,
          reason: 'У корневого узла не должно быть данных',
        );
      });
    });

    group('Node Operations |', () {
      test('adding_new_node_makes_it_accessible_in_graph', () {
        // Arrange
        final node = Node('test_node');

        // Act
        graph.addNode(node);

        // Assert
        expect(
          graph.containsNode(node.key),
          isTrue,
          reason: 'Узел должен быть добавлен в граф',
        );
        expect(
          graph.getNodeByKey(node.key),
          equals(node),
          reason: 'Должен возвращаться тот же узел, который был добавлен',
        );
      });

      test('cannot_add_node_with_existing_key', () {
        // Arrange
        final node = Node('test_node');
        graph.addNode(node);

        // Act & Assert
        expect(
          () => graph.addNode(node),
          throwsA(
            predicate(
                (e) => e is StateError && e.message == 'Graph already contains node "test_node"'),
          ),
          reason: 'Нельзя добавить узел с существующим ключом',
        );
      });

      test('removing_node_makes_it_inaccessible', () {
        // Arrange
        final node = Node('test_node');
        graph.addNode(node);

        // Act
        graph.removeNode(node);

        // Assert
        expect(
          graph.containsNode(node.key),
          isFalse,
          reason: 'Узел должен быть удален из графа',
        );
      });

      test('cannot_remove_non_existent_node', () {
        // Arrange
        final node = Node('test_node');

        // Act & Assert
        expect(
          () => graph.removeNode(node),
          throwsA(
            predicate(
                (e) => e is StateError && e.message == 'Node "test_node" does not exist in graph'),
          ),
          reason: 'Нельзя удалить несуществующий узел',
        );
      });

      test('root_node_cannot_be_removed', () {
        // Act & Assert
        expect(
          () => graph.removeNode(root),
          throwsA(
            predicate((e) => e is StateError && e.message == 'Root node cannot be removed'),
          ),
          reason: 'Корневой узел не может быть удален',
        );
      });

      test('getting_node_by_key_returns_correct_node_or_null', () {
        // Arrange
        final node = Node('test_node');
        graph.addNode(node);

        // Act & Assert
        expect(
          graph.getNodeByKey(node.key),
          equals(node),
          reason: 'Должен вернуть тот же узел по ключу',
        );
        expect(
          graph.getNodeByKey('non_existent'),
          isNull,
          reason: 'Должен вернуть null для несуществующего ключа',
        );
      });

      test('node_existence_check_works_through_lifecycle', () {
        // Arrange
        final node = Node('test_node');

        // Act & Assert - проверяем начальное состояние
        expect(
          graph.containsNode(node.key),
          isFalse,
          reason: 'Изначально узел не должен существовать',
        );

        // Act - добавляем узел
        graph.addNode(node);

        // Assert - проверяем после добавления
        expect(
          graph.containsNode(node.key),
          isTrue,
          reason: 'Узел должен существовать после добавления',
        );

        // Act - удаляем узел
        graph.removeNode(node);

        // Assert - проверяем после удаления
        expect(
          graph.containsNode(node.key),
          isFalse,
          reason: 'Узел не должен существовать после удаления',
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

      test('adding_edge_automatically_creates_missing_nodes', () {
        // Act
        graph.addEdge(parent, child);

        // Assert
        expect(
          graph.nodes.length,
          equals(3),
          reason: 'Должно быть 3 узла: root + parent + child',
        );
        expect(
          graph.edgesWithEmptySets[parent],
          contains(child),
          reason: 'Должно быть создано ребро от parent к child',
        );
        expect(
          graph.parents[child],
          equals(parent),
          reason: 'У child должен быть установлен правильный родитель',
        );
      });

      test('adding_edge_between_existing_nodes_preserves_node_count', () {
        // Arrange
        graph.addNode(parent);
        graph.addNode(child);

        // Act
        graph.addEdge(parent, child);

        // Assert
        expect(
          graph.nodes.length,
          equals(3),
          reason: 'Количество узлов не должно измениться',
        );
        expect(
          graph.edgesWithEmptySets[parent],
          contains(child),
          reason: 'Должно быть создано ребро от parent к child',
        );
        expect(
          graph.parents[child],
          equals(parent),
          reason: 'У child должен быть установлен правильный родитель',
        );
      });

      test('node_cannot_have_multiple_parents', () {
        // Arrange
        final parent1 = Node('parent1');
        final parent2 = Node('parent2');
        final child = Node('child');
        graph.addEdge(parent1, child);

        // Act & Assert
        expect(
          () => graph.addEdge(parent2, child),
          throwsA(
            predicate((e) =>
                e is StateError && e.message == 'Node "child" already has a parent "parent1"'),
          ),
          reason: 'Узел не может иметь более одного родителя',
        );
      });

      test('removing_edge_breaks_parent_child_relationship', () {
        // Arrange
        graph.addEdge(parent, child);

        // Act
        graph.removeEdge(parent, child);

        // Assert
        expect(
          graph.edges[parent]?.isEmpty ?? true,
          isTrue,
          reason: 'После удаления ребра множество должно быть пустым',
        );
        expect(
          graph.parents[child],
          isNull,
          reason: 'После удаления ребра родитель должен быть null',
        );
      });

      test('cannot_remove_non_existent_edge', () {
        // Act & Assert
        expect(
          () => graph.removeEdge(parent, child),
          throwsStateError,
          reason: 'Удаление несуществующего ребра должно вызвать ошибку',
        );
      });

      test('removing_node_cleans_up_all_connected_edges', () {
        // Arrange
        final parent = Node('parent');
        final child1 = Node('child1');
        final child2 = Node('child2');

        graph.addEdge(parent, child1);
        graph.addEdge(parent, child2);

        // Act
        graph.removeNode(parent);

        // Assert
        expect(
          graph.containsNode(parent.key),
          isFalse,
          reason: 'Узел должен быть удален из графа',
        );
        expect(
          graph.parents[child1],
          isNull,
          reason: 'Родитель child1 должен быть null',
        );
        expect(
          graph.parents[child2],
          isNull,
          reason: 'Родитель child2 должен быть null',
        );
      });

      test('cannot_create_cyclic_dependencies', () {
        // Arrange
        final node1 = Node('node1');
        final node2 = Node('node2');

        graph.addEdge(node1, node2);

        // Act & Assert
        expect(
          () => graph.addEdge(node2, node1),
          throwsStateError,
          reason: 'Создание цикла должно вызвать ошибку',
        );
      });

      test('returns_correct_node_edges', () {
        // Arrange
        final parent = Node('parent');
        final child1 = Node('child1');
        final child2 = Node('child2');

        graph.addNode(parent);
        graph.addNode(child1);
        graph.addNode(child2);

        // Assert - проверяем пустой узел
        expect(
          graph.getNodeEdges(parent),
          isEmpty,
          reason: 'У нового узла не должно быть ребер',
        );

        // Act - добавляем ребра
        graph.addEdge(parent, child1);
        graph.addEdge(parent, child2);

        // Assert - проверяем после добавления
        final edges = graph.getNodeEdges(parent);
        expect(
          edges.length,
          equals(2),
          reason: 'Должно быть два ребра',
        );
        expect(
          edges,
          containsAll([child1, child2]),
          reason: 'Должны присутствовать оба дочерних узла',
        );
      });

      test('get_node_parent_returns_correct_node', () {
        final parent = Node('parent');
        final child = Node('child');

        expect(graph.getNodeParent(child), isNull);

        graph.addEdge(parent, child);
        expect(graph.getNodeParent(child), equals(parent));

        graph.removeEdge(parent, child);
        expect(graph.getNodeParent(child), isNull);
      });

      test('adds_edge_with_new_nodes_automatically', () {
        // Arrange
        final parent = Node('parent');
        final child = Node('child');

        // Act
        graph.addEdge(parent, child);

        // Assert
        expect(
          graph.containsNode(parent.key),
          isTrue,
          reason: 'Родительский узел должен быть автоматически добавлен',
        );
        expect(
          graph.containsNode(child.key),
          isTrue,
          reason: 'Дочерний узел должен быть автоматически добавлен',
        );
        expect(
          graph.parents[child],
          equals(parent),
          reason: 'Должна быть установлена корректная связь parent -> child',
        );
      });

      test('remove_edge_keeps_nodes', () {
        final parent = Node('parent');
        final child = Node('child');

        graph.addEdge(parent, child);
        graph.removeEdge(parent, child);

        expect(graph.containsNode(parent.key), isTrue);
        expect(graph.containsNode(child.key), isTrue);
        expect(graph.edges[parent], isEmpty);
      });
    });

    group('Clear Operations |', () {
      test('clear_graph', () {
        final node1 = Node('node1');
        final node2 = Node('node2');
        graph.addEdge(node1, node2);
        graph.updateNodeData(node1.key, 'data1');

        graph.clear();

        expect(graph.nodes.length, equals(1)); // root node should remain
        expect(graph.containsNode(root.key), isTrue);
        expect(graph.edges.isEmpty, isTrue);
        expect(graph.parents.isEmpty, isTrue);
        expect(graph.nodeData.isEmpty, isTrue);
      });
    });
  });

  group('Node Data Operations |', () {
    test('successfully_updates_node_data', () {
      // Arrange
      final node = Node('test_node');
      graph.addNode(node);
      const testData = 'test_data';

      // Act
      graph.updateNodeData(node.key, testData);

      // Assert
      expect(
        graph.getNodeData(node.key),
        equals(testData),
        reason: 'Данные узла должны быть обновлены',
      );
    });

    test('throws_on_updating_non_existent_node_data', () {
      // Act & Assert
      expect(
        () => graph.updateNodeData('non-existent', 'data'),
        throwsA(
          predicate((e) =>
              e is StateError &&
              e.message == 'Cannot update data for non-existent node "non-existent"'),
        ),
        reason: 'Нельзя обновить данные несуществующего узла',
      );
    });

    test('removes_node_data_when_removing_node', () {
      // Arrange
      final node = Node('test_node');
      graph.addNode(node);
      graph.updateNodeData(node.key, 'test_data');

      // Act
      graph.removeNode(node);

      // Assert
      expect(
        graph.nodeData[node.key],
        isNull,
        reason: 'Данные узла должны быть удалены вместе с узлом',
      );
    });

    test('clears_node_data_when_clearing_graph', () {
      // Arrange
      final node = Node('test_node');
      graph.addNode(node);
      graph.updateNodeData(node.key, 'test_data');

      // Act
      graph.clear();

      // Assert
      expect(
        graph.nodeData.isEmpty,
        isTrue,
        reason: 'После очистки графа все данные должны быть удалены',
      );
    });
  });

  group('Graph Validation |', () {
    test('enforces_unique_node_keys', () {
      // Arrange
      final node1 = Node('same_key');
      final node2 = Node('same_key');

      graph.addNode(node1);

      // Act & Assert
      expect(
        () => graph.addNode(node2),
        throwsStateError,
        reason: 'Добавление узла с существующим ключом должно вызвать ошибку',
      );
    });

    test('validates_node_operations', () {
      // Arrange
      final node = Node('node');

      // Act & Assert - проверяем самоссылающееся ребро
      expect(
        () => graph.addEdge(root, root),
        throwsStateError,
        reason: 'Создание самоссылающегося ребра должно вызвать ошибку',
      );

      // Act & Assert - проверяем доступ к несуществующему узлу
      expect(
        () => graph.getNodeEdges(Node('non_existent')),
        throwsStateError,
        reason: 'Получение ребер несуществующего узла должно вызвать ошибку',
      );

      // Act & Assert - проверяем обновление данных несуществующего узла
      expect(
        () => graph.updateNodeData('non_existent', 'data'),
        throwsStateError,
        reason: 'Обновление данных несуществующего узла должно вызвать ошибку',
      );
    });

    test('validates_empty_keys', () {
      // Act & Assert - проверяем добавление узла с пустым ключом
      expect(
        () => graph.addNode(Node('')),
        throwsArgumentError,
        reason: 'Добавление узла с пустым ключом должно вызвать ошибку',
      );

      // Act & Assert - проверяем получение узла с пустым ключом
      expect(
        () => graph.getNodeByKey(''),
        throwsArgumentError,
        reason: 'Получение узла с пустым ключом должно вызвать ошибку',
      );
    });
  });

  group('Graph State Operations |', () {
    test('keeps_root_after_clear', () {
      // Arrange
      final node = Node('test_node');
      graph.addNode(node);

      // Act
      graph.clear();

      // Assert
      expect(
        graph.containsNode(root.key),
        isTrue,
        reason: 'Корневой узел должен сохраниться после очистки',
      );
      expect(
        graph.getNodeEdges(root),
        isEmpty,
        reason: 'У корневого узла не должно остаться ребер',
      );
    });

    test('adds_multiple_nodes_with_edges_correctly', () {
      // Arrange
      final parent = Node('parent');
      final child1 = Node('child1');
      final child2 = Node('child2');

      // Act
      graph.addEdge(parent, child1);
      graph.addEdge(parent, child2);

      // Assert
      expect(
        graph.containsNode(parent.key),
        isTrue,
        reason: 'Родительский узел должен быть добавлен',
      );
      expect(
        graph.getNodeEdges(parent),
        containsAll([child1, child2]),
        reason: 'Должны быть добавлены все ребра',
      );
    });

    test('removes_node_and_updates_relationships', () {
      // Arrange
      final parent = Node('parent');
      final child1 = Node('child1');
      final child2 = Node('child2');
      graph.addEdge(parent, child1);
      graph.addEdge(parent, child2);

      // Act
      graph.removeNode(child1);

      // Assert
      expect(
        graph.containsNode(child1.key),
        isFalse,
        reason: 'Узел должен быть удален',
      );
      expect(
        graph.getNodeEdges(parent),
        contains(child2),
        reason: 'Оставшиеся ребра должны сохраниться',
      );
    });

    test('maintains_parent_child_relationships_through_middle_node_removal', () {
      // Arrange
      final parent = Node('parent');
      final middle = Node('middle');
      final child = Node('child');

      graph.addEdge(parent, middle);
      graph.addEdge(middle, child);

      // Act
      graph.removeNode(middle);

      // Assert
      expect(
        graph.getNodeParent(child),
        isNull,
        reason: 'Дочерний узел должен потерять родителя',
      );
      expect(
        graph.getNodeEdges(parent),
        isEmpty,
        reason: 'Родительский узел должен потерять ребра',
      );
      expect(
        graph.containsNode(middle.key),
        isFalse,
        reason: 'Промежуточный узел должен быть удален',
      );
    });
  });

  group('Error Handling |', () {
    test('operations_with_non_existent_nodes_throw_errors', () {
      final node = Node('node');
      final nonExistent = Node('non_existent');

      graph.addNode(node);

      expect(() => graph.getNodeEdges(nonExistent), throwsStateError);
      expect(() => graph.removeEdge(node, nonExistent), throwsStateError);
      expect(() => graph.removeEdge(nonExistent, node), throwsStateError);
    });

    test('invalid_graph_operations_throw_appropriate_errors', () {
      final node1 = Node('node1');
      final node2 = Node('node2');
      final node3 = Node('node3');

      // Добавляем первое ребро
      graph.addEdge(node1, node2);

      expect(
        () => graph.addEdge(node1, node2),
        throwsStateError,
        reason: 'Cannot add duplicate edge',
      );

      expect(
        () => graph.addEdge(node2, node1),
        throwsStateError,
        reason: 'Cannot create cycle',
      );

      // Пытаемся добавить второго родителя к node2
      expect(
        () => graph.addEdge(node3, node2),
        throwsA(
          predicate(
              (e) => e is StateError && e.message == 'Node "node2" already has a parent "node1"'),
        ),
        reason: 'Cannot add edge to node with existing parent',
      );
    });
  });

  group('Edge Cases |', () {
    test('node_with_very_long_key_is_handled_correctly', () {
      // Arrange
      final longKey = 'a' * 1000;
      final node = Node(longKey);

      // Act
      graph.addNode(node);

      // Assert
      expect(
        graph.containsNode(longKey),
        isTrue,
        reason: 'Узел с длинным ключом должен быть добавлен корректно',
      );
    });

    test('special_characters_in_node_key_are_preserved', () {
      // Arrange
      final specialKey = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
      final node = Node(specialKey);

      // Act
      graph.addNode(node);

      // Assert
      expect(
        graph.getNodeByKey(specialKey),
        equals(node),
        reason: 'Специальные символы в ключе должны сохраняться',
      );
    });

    test('large_number_of_children_handled_correctly', () {
      // Arrange
      final parent = Node('parent');
      final children = List.generate(1000, (i) => Node('child$i'));

      // Act
      for (final child in children) {
        graph.addEdge(parent, child);
      }

      // Assert
      expect(
        graph.getNodeEdges(parent).length,
        equals(1000),
        reason: 'Граф должен корректно обрабатывать большое количество дочерних узлов',
      );
    });

    test('deep_tree_traversal_works_correctly', () {
      // Arrange - создаем глубокое дерево
      Node current = root;
      for (var i = 0; i < 100; i++) {
        final next = Node('level$i');
        graph.addEdge(current, next);
        current = next;
      }

      // Act
      final depth = graph.getDepths()[current];

      // Assert
      expect(
        depth,
        equals(100),
        reason: 'Граф должен корректно обрабатывать глубокие деревья',
      );
    });
  });

  group('Performance Critical Operations |', () {
    test('batch_operations_are_efficient', () {
      // Arrange
      final startTime = DateTime.now();
      final nodes = List.generate(1000, (i) => Node('node$i'));

      // Act
      for (final node in nodes) {
        graph.addNode(node);
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      expect(
        duration.inMilliseconds,
        lessThan(1000),
        reason: 'Пакетные операции должны выполняться эффективно',
      );
    });
  });

  group('Concurrent Modifications |', () {
    test('modifications_during_iteration_are_handled_safely', () {
      // Arrange
      final parent = Node('parent');
      final children = List.generate(10, (i) => Node('child$i'));
      for (final child in children) {
        graph.addEdge(parent, child);
      }

      // Act & Assert
      final iterator = graph.breadthIterator;
      expect(
        () {
          while (iterator.moveNext()) {
            final node = iterator.current;
            if (node.key == 'child5') {
              graph.removeNode(node);
            }
          }
        },
        returnsNormally,
        reason: 'Модификации во время итерации должны обрабатываться безопасно',
      );
    });
  });
}
