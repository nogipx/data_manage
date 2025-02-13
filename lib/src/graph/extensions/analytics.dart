import 'dart:math';

import '../_index.dart';

/// Extension для аналитических методов графа
extension GraphAnalytics<T> on IGraph<T> {
  /// Анализирует структуру графа и возвращает статистику
  Map<String, dynamic> analyzeStructure() {
    int maxBranching = 0;
    double avgBranching = 0;
    int totalNodes = 0;
    int maxDepth = 0;
    final branchingDistribution = <int, int>{};

    for (final node in nodes.values) {
      final edges = getNodeEdges(node);
      final branching = edges.length;

      maxBranching = max(maxBranching, branching);
      branchingDistribution[branching] = (branchingDistribution[branching] ?? 0) + 1;

      totalNodes++;
    }

    avgBranching = totalNodes > 1
        ? branchingDistribution.entries.map((e) => e.key * e.value).reduce((a, b) => a + b) /
            (totalNodes - 1) // исключаем листья
        : 0;

    final depths = getDepths();
    maxDepth = depths.values.isEmpty ? 0 : depths.values.reduce(max);

    return {
      'totalNodes': totalNodes,
      'maxBranching': maxBranching,
      'averageBranching': avgBranching,
      'maxDepth': maxDepth,
      'branchingDistribution': branchingDistribution,
      'isBalanced': isBalanced(),
      'centralNodes': findCentralNodes().map((n) => n.key).toList(),
      'leafCount': getLeaves().length,
    };
  }

  /// Проверяет, сбалансировано ли дерево
  /// Дерево считается сбалансированным, если разница в глубине
  /// любых двух поддеревьев не превышает 1
  bool isBalanced() {
    bool balanced = true;

    int getHeight(Node node) {
      if (!balanced) return 0;

      final children = getNodeEdges(node);
      if (children.isEmpty) return 0;

      int minHeight = 999999;
      int maxHeight = 0;

      for (final child in children) {
        final height = getHeight(child) + 1;
        minHeight = min(minHeight, height);
        maxHeight = max(maxHeight, height);
      }

      if (maxHeight - minHeight > 1) {
        balanced = false;
      }

      return maxHeight;
    }

    getHeight(root);
    return balanced;
  }

  /// Находит центральные узлы графа
  /// Центральным считается узел, от которого максимальное
  /// расстояние до любого листа минимально
  Set<Node> findCentralNodes() {
    if (nodes.length <= 2) return nodes.values.toSet();

    var current = nodes.values.toSet();

    while (current.length > 2) {
      final leaves = current
          .where(
            (node) => getNodeEdges(node).intersection(current).isEmpty,
          )
          .toSet();

      current = current.difference(leaves);
    }

    return current;
  }

  /// Находит повторяющиеся поддеревья
  Map<String, List<Node>> findRepeatingSubtrees() {
    final patterns = <String, List<Node>>{};

    String getSubtreePattern(Node root) {
      final children = getNodeEdges(root).toList()..sort((a, b) => a.key.compareTo(b.key));
      final childPatterns = children.map(getSubtreePattern).join(',');
      return '(${root.key}[$childPatterns])';
    }

    // Собираем паттерны для всех узлов
    for (final node in nodes.values) {
      final pattern = getSubtreePattern(node);
      patterns.putIfAbsent(pattern, () => []).add(node);
    }

    // Оставляем только повторяющиеся
    return Map.fromEntries(
      patterns.entries.where((e) => e.value.length > 1),
    );
  }

  /// Проверяет, изоморфны ли два графа
  /// Два графа изоморфны, если они имеют одинаковую структуру,
  /// независимо от порядка потомков
  bool isIsomorphicTo(IGraph<dynamic> other) {
    bool areSubtreesIsomorphic(Node node1, Node node2) {
      final children1 = getNodeEdges(node1);
      final children2 = other.getNodeEdges(node2);

      if (children1.length != children2.length) return false;
      if (children1.isEmpty) return true;

      // Для каждого ребенка из первого графа
      // должен найтись изоморфный из второго
      final used = <Node>{};
      for (final child1 in children1) {
        bool foundMatch = false;

        for (final child2 in children2) {
          if (!used.contains(child2) && areSubtreesIsomorphic(child1, child2)) {
            used.add(child2);
            foundMatch = true;
            break;
          }
        }

        if (!foundMatch) return false;
      }

      return true;
    }

    return areSubtreesIsomorphic(root, other.root);
  }

  /// Вычисляет "расстояние редактирования" между графами
  /// (минимальное количество операций для превращения одного графа в другой)
  int calculateEditDistance(IGraph<dynamic> other) {
    int subtreeEditDistance(Node? node1, Node? node2) {
      if (node1 == null && node2 == null) return 0;
      if (node1 == null) return 1; // нужно добавить узел
      if (node2 == null) return 1; // нужно удалить узел

      final children1 = getNodeEdges(node1).toList();
      final children2 = other.getNodeEdges(node2).toList();

      // Базовая стоимость - отличаются ли узлы
      int cost = node1.key != node2.key ? 1 : 0;

      // Находим минимальную стоимость сопоставления детей
      final m = children1.length;
      final n = children2.length;
      final dp = List.generate(
        m + 1,
        (i) => List.generate(n + 1, (j) => 0),
      );

      // Инициализация
      for (int i = 0; i <= m; i++) {
        dp[i][0] = i;
      }
      for (int j = 0; j <= n; j++) {
        dp[0][j] = j;
      }

      // Заполняем динамику
      for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
          dp[i][j] = min(
            dp[i - 1][j] + 1, // удаление
            min(
              dp[i][j - 1] + 1, // вставка
              dp[i - 1][j - 1] +
                  subtreeEditDistance(
                    children1[i - 1],
                    children2[j - 1],
                  ), // замена или совпадение
            ),
          );
        }
      }

      return cost + dp[m][n];
    }

    return subtreeEditDistance(root, other.root);
  }
}
