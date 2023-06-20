import 'dart:developer' as dev;

import '_index.dart';

class Tree<T> {
  final Node root;

  final Map<String, Node> _nodes = {};
  Map<String, Node> get nodes => Map.unmodifiable(_nodes);

  final Map<String, T> _nodeData = {};
  Map<String, T> get nodeData => Map.unmodifiable(_nodeData);

  final Map<Node, Set<Node>> _edges = {};
  Map<Node, Set<Node>> get edges => Map.unmodifiable(_edges);

  final Map<Node, Node> _parents = {};
  Map<Node, Node> get parents => Map.unmodifiable(_parents);

  Tree({
    required this.root,
    Map<String, Node> nodes = const {},
    Map<String, T> nodesData = const {},
    Map<Node, Set<Node>> edges = const {},
    Map<Node, Node> parents = const {},
  }) {
    addNode(root);
    _nodes.addAll(nodes);
    _nodeData.addAll(nodesData);
    _edges.addAll(edges);
    _parents.addAll(parents);
  }

  // ADD OPERATIONS

  void addNode(Node node) {
    _nodes[node.key] = node;
    _edges[node] = {};
  }

  void addEdge(Node first, Node second) {
    if (!containsNode(first.key)) {
      addNode(first);
    }
    if (!containsNode(second.key)) {
      addNode(second);
    }

    _parents[second] = first;

    final firstEdges = _edges.putIfAbsent(first, () => {});
    firstEdges.add(second);
  }

  // REMOVE OPERATIONS

  void removeNode(Node node) {
    _guardGraphContainsNode(node);
    _nodes.remove(node);
    _edges.remove(node) ?? {};
    for (final edges in _edges.values) {
      edges.remove(node);
    }
    _parents.remove(node);
    _parents.removeWhere((key, value) => value == node);
  }

  void removeEdge(Node first, Node second) {
    _guardGraphContainsNode(first, extra: '(parent)');
    _guardGraphContainsNode(second, extra: '(child)');

    _parents.remove(second);

    final firstEdges = _edges.putIfAbsent(first, () => {});
    firstEdges.remove(second);
  }

  void clear() {
    _nodes.clear();
    _nodeData.clear();
    _edges.clear();
    _parents.clear();
  }

  // EXTRA DATA OPERATIONS

  T? getNodeData(String key) => _nodeData[key];

  void updateNodeData(String key, T data) => _nodeData[key] = data;

  // ACCESS OPERATIONS

  Node? getNodeByKey(String key) => _nodes[key];

  bool containsNode(String nodeKey) => _nodes.containsKey(nodeKey);

  Node? getNodeParent(Node node) => _parents[node];

  Set<Node> getNodeEdges(Node node) => _edges[node] ?? {};

  // METHODS

  /// ## Обход в ширину.
  int visitBreadth(VisitCallback visit, {Node? startNode}) {
    final visited = <Node, bool>{};
    final queue = [startNode ?? root];
    int level = -1;

    while (queue.isNotEmpty) {
      int levelSize = queue.length;
      level++;

      while (levelSize-- != 0) {
        final node = queue.removeAt(0);

        visited[node] = true;
        final visitResult = visit(node);

        if (visitResult == VisitResult.breakVisit) {
          return level;
        } else {
          for (final child in _edges[node] ?? {}) {
            if (visited[child] != true) {
              queue.add(child);
            }
          }
        }
      }
    }
    return startNode != null ? -1 : level;
  }

  /// ## Обход в глубину.
  void visitDepth(VisitCallback visit, {Node? startNode}) {
    final visited = <Node, bool>{};
    final stack = <Node>[];
    stack.add(startNode ?? root);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();

      if (visited[node] != true) {
        visited[node] = true;
        final visitResult = visit(node);
        if (visitResult == VisitResult.breakVisit) {
          break;
        }

        for (final child in _edges[node] ?? {}) {
          if (visited[child] != true) {
            stack.add(child);
          }
        }
      }
    }
  }

  /// ## Рекурсивный обход в глубину с сохранением обратного пути.
  void visitDepthBacktrack(BacktrackCallback visit) {
    _visitDepthBacktrack(root, visit, [root]);
  }

  void _visitDepthBacktrack(
    Node node,
    BacktrackCallback<T> callback,
    List<Node> state,
  ) {
    final isSolution = callback(state);
    if (isSolution == VisitResult.breakVisit) {
      return;
    }

    for (final child in _edges[node] ?? {}) {
      state.add(child);
      _visitDepthBacktrack(child, callback, state);
      state.remove(child);
    }
  }

  /// ## Возвращает список всех связанных вершин с заданной.
  /// От корня до заданной вершины.
  Set<Node> getPathToNode(Node node) {
    return getVerticalPathBetweenNodes(root, node);
  }

  /// ## Возвращает список всех связанных вершин с заданной.
  /// От корня до листьев.
  Set<Node> getFullVerticalPath(Node node) {
    final upwardPath = getVerticalPathBetweenNodes(root, node);
    visitDepth(
      startNode: node,
      (node) {
        upwardPath.add(node);
        return VisitResult.continueVisit;
      },
    );

    return upwardPath;
  }

  /// ## Возвращает путь между двумя вершинами поддерева.
  ///
  /// Определяет какая вершина находится выше.
  /// Затем поднимается вверх по графу до нахождения родительской вершины.
  /// ---
  /// Если в процессе прохода родительская вершина не найдена
  /// (например, у корня нет родителей),
  /// то останавливается и возвращает пустой путь.
  /// ---
  /// Можно передать уже просчитанные глубины вершин.
  /// Если просчитанные глубины не переданы,
  /// то глубина для каждой вершины вычисляется.
  Set<Node> getVerticalPathBetweenNodes(
    Node first,
    Node second, {
    Map<String, int>? depths,
  }) {
    late final Node parent;
    late final Node child;

    final firstDepth = depths?[first.key] ?? getNodeLevel(first);
    final secondDepth = depths?[second.key] ?? getNodeLevel(second);

    if (firstDepth < secondDepth) {
      parent = first;
      child = second;
    } else {
      parent = second;
      child = first;
    }

    Node current = child;
    final List<Node> path = [current];

    while (current != parent) {
      final tempParent = getNodeParent(current);
      if (tempParent != null) {
        path.insert(0, tempParent);
        current = tempParent;
      } else {
        path.clear();
        break;
      }
    }

    return path.toSet();
  }

  /// ## Возвращает список детей родителя данной вершины.
  Set<Node> getSiblings(Node node) {
    final parent = getNodeParent(node);

    if (parent != null) {
      final siblings = getNodeEdges(parent);
      return siblings;
    }

    return const {};
  }

  /// ## Возвращает список листьев.
  ///
  /// Если [startNode] указан, то возвращает список листьев,
  /// для которых [startNode] является общим родителем.
  ///
  /// Если [startNode] не указан, то возвращает
  /// список всех листьев дерева.
  Set<Node> getLeaves({
    Node? startNode,
  }) {
    final start = startNode ?? root;
    final result = <Node>{};
    visitBreadth(
      startNode: start,
      (node) {
        final nodeEdges = getNodeEdges(node);
        if (nodeEdges.isEmpty) {
          result.add(node);
        }
        return VisitResult.continueVisit;
      },
    );

    return result;
  }

  /// ## Возвращает глубину заданной вершины.
  ///
  /// Выполняет обход в ширину в поисках вершины.
  /// При нахождении совпадения прерывает обход
  /// и возвращает глубину вершины.
  int getNodeLevel(Node node) {
    bool found = false;
    final level = visitBreadth((n) {
      if (n == node) {
        found = true;
        return VisitResult.breakVisit;
      }
      return VisitResult.continueVisit;
    });
    return found ? level : -1;
  }

  /// ## Возвращает глубину всех вершин графа.
  ///
  /// Выполняет проход учитывая обратный путь.
  /// Для каждой вершины сохраняет ее глубину.
  Map<Node, int> getDepths() {
    final result = <Node, int>{};
    visitDepthBacktrack((path) {
      if (path.isNotEmpty) {
        final node = path.last;
        final index = path.length - 1;
        result[node] = index;
      }
      return VisitResult.continueVisit;
    });
    return result;
  }

  void printTree() {
    visitDepthBacktrack((path) {
      if (path.isNotEmpty) {
        final level = path.length - 1;
        final node = path.last;
        final data = getNodeData(node.key);
        dev.log(
          '${'|  ' * level}$node ${data != null ? '[data: $data]' : ''}',
          name: 'Tree.print',
          level: 800,
        );
      }
      return VisitResult.continueVisit;
    });
  }

  void _guardGraphContainsNode(Node node, {String extra = ''}) {
    if (!_nodes.containsKey(node.key)) {
      throw Exception('Graph does not contains $node. $extra');
    }
  }

  /// ## Клонирует дерево.
  Tree clone() => Tree(
        root: root,
        nodes: nodes,
        edges: edges,
        nodesData: nodeData,
        parents: parents,
      );
}
