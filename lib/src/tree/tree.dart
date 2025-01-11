import 'dart:collection';
import '_index.dart';

class Graph<T> implements IGraph<T>, IGraphEditable<T> {
  @override
  final Node root;

  final Map<String, Node> _nodes = {};
  @override
  Map<String, Node> get nodes => Map.unmodifiable(_nodes);

  final Map<String, T> _nodeData = {};
  @override
  Map<String, T> get nodeData => Map.unmodifiable(_nodeData);

  final Map<Node, Set<Node>> _edges = {};
  @override
  Map<Node, Set<Node>> get edges => Map.unmodifiable(_edges);

  final Map<Node, Node> _parents = {};
  @override
  Map<Node, Node> get parents => Map.unmodifiable(_parents);

  final bool allowManyParents;

  Graph({
    required this.root,
    Map<String, Node> nodes = const {},
    Map<String, T> nodesData = const {},
    Map<Node, Set<Node>> edges = const {},
    Map<Node, Node> parents = const {},
    this.allowManyParents = false,
  }) {
    // Если в переданных nodes уже есть root, то при желании можно проверить,
    // чтобы не перезаписать _nodes[root.key]. Пока что просто добавляем вручную:
    addNode(root);
    _nodes.addAll(nodes);
    _nodeData.addAll(nodesData);
    _edges.addAll(edges);
    _parents.addAll(parents);
  }

  // ==================================
  // ADD OPERATIONS
  // ==================================

  @override
  void addNode(Node node) {
    if (containsNode(node.key)) {
      throw StateError('Graph already contains node "${node.key}"');
    }
    _nodes[node.key] = node;
  }

  @override
  void addEdge(Node parent, Node child) {
    if (!containsNode(parent.key)) {
      addNode(parent);
    }
    if (!containsNode(child.key)) {
      addNode(child);
    }

    final existingParent = getNodeParent(child);
    if (!allowManyParents && existingParent != null) {
      throw StateError(
        'Node "${child.key}" already has a parent "${existingParent.key}"',
      );
    }

    _parents[child] = parent;
    // Явно указываем тип Set<Node> при создании:
    final childSet = _edges.putIfAbsent(parent, () => <Node>{});
    childSet.add(child);
  }

  // ==================================
  // REMOVE OPERATIONS
  // ==================================

  @override
  void removeNode(Node node) {
    _assertNodeExists(node);
    _nodes.remove(node.key);

    // Удаляем исходящие рёбра (children)
    _edges.remove(node);

    // Удаляем во всех остальных списках children
    for (final edges in _edges.values) {
      edges.remove(node);
    }

    // Удаляем родителя, если был
    _parents.remove(node);

    // Удаляем записи, где этот node являлся родителем
    _parents.removeWhere((key, value) => value == node);
  }

  @override
  void removeEdge(Node parent, Node child) {
    _assertNodeExists(parent, extra: '(parent)');
    _assertNodeExists(child, extra: '(child)');

    // Удаляем связь parent->child из _parents
    _parents.remove(child);

    // Удаляем child из edges родителя
    final childSet = _edges.putIfAbsent(parent, () => <Node>{});
    childSet.remove(child);
    if (childSet.isEmpty) {
      _edges.remove(parent);
    }
  }

  @override
  void clear() {
    _nodes.clear();
    _nodeData.clear();
    _edges.clear();
    _parents.clear();
  }

  // ==================================
  // EXTRA DATA OPERATIONS
  // ==================================

  @override
  T? getNodeData(String key) => _nodeData[key];

  @override
  void updateNodeData(String key, T data) => _nodeData[key] = data;

  // ==================================
  // ACCESS OPERATIONS
  // ==================================

  @override
  Node? getNodeByKey(String key) => _nodes[key];

  @override
  bool containsNode(String nodeKey) => _nodes.containsKey(nodeKey);

  @override
  Node? getNodeParent(Node node) => _parents[node];

  @override
  Set<Node> getNodeEdges(Node node) => _edges[node] ?? {};

  // ==================================
  // METHODS
  // ==================================

  @override
  IGraphEditable<T> selectRoot(String key) {
    _assertNodeExists(Node(key));
    final root = getNodeByKey(key)!;
    final tree = Graph<T>(root: root);

    final currentPath = [root];
    _visitDepthBacktrack(
      root,
      (path) {
        if (path.length < 2) {
          return VisitResult.continueVisit;
        }

        final parent = path[path.length - 2];
        if (!tree.containsNode(parent.key)) {
          tree.addNode(parent);
        }

        final child = path[path.length - 1];
        if (!tree.containsNode(child.key)) {
          tree.addNode(child);
        }

        tree.addEdge(parent, child);

        return VisitResult.continueVisit;
      },
      currentPath,
    );

    return tree;
  }

  /// ## Breadth-first search (BFS)
  /// Возвращает "уровень" (глубину) вершины, на которой поиск был прерван,
  /// либо полный уровень "глубины", если обход завершён.
  @override
  int visitBreadth(VisitCallback visit, {Node? startNode}) {
    final visited = <Node, bool>{};
    // Вместо List используем Queue, чтобы не делать removeAt(0).
    final queue = Queue<Node>();
    queue.add(startNode ?? root);

    int level = -1;

    while (queue.isNotEmpty) {
      final levelSize = queue.length;
      level++;

      // Обрабатываем все узлы текущего уровня
      for (int i = 0; i < levelSize; i++) {
        final node = queue.removeFirst();

        if (visited[node] == true) {
          continue;
        }
        visited[node] = true;

        final visitResult = visit(node);
        if (visitResult == VisitResult.breakVisit) {
          return level;
        }

        // Добавляем детей в очередь
        for (final child in _edges[node] ?? {}) {
          if (visited[child] != true) {
            queue.add(child);
          }
        }
      }
    }

    // Если стартовая нода была не root и ничего не нашли - возвращаем -1;
    return startNode != null ? -1 : level;
  }

  /// ## Depth-first search (DFS) (итеративный вариант).
  @override
  void visitDepth(VisitCallback visit, {Node? startNode}) {
    final visited = <Node, bool>{};
    final stack = <Node>[];
    stack.add(startNode ?? root);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (visited[node] == true) {
        continue;
      }
      visited[node] = true;

      final visitResult = visit(node);
      if (visitResult == VisitResult.breakVisit) {
        break;
      }

      // Добавляем в стек всех детей
      for (final child in _edges[node] ?? {}) {
        if (visited[child] != true) {
          stack.add(child);
        }
      }
    }
  }

  /// ## Рекурсивный DFS с backtracking.
  @override
  void visitDepthBacktrack(BacktrackCallback visit) {
    _visitDepthBacktrack(root, visit, [root]);
  }

  void _visitDepthBacktrack(
    Node node,
    BacktrackCallback<T> callback,
    List<Node> state,
  ) {
    final result = callback(state);
    if (result == VisitResult.breakVisit) {
      return;
    }

    for (final child in _edges[node] ?? {}) {
      state.add(child);
      _visitDepthBacktrack(child, callback, state);
      state.removeLast();
    }
  }

  /// ## Возвращает путь от корня до конкретной вершины [node].
  @override
  Set<Node> getPathToNode(Node node) {
    return getVerticalPathBetweenNodes(root, node);
  }

  /// ## Возвращает все вершины от корня до листьев, включая путь до [node].
  @override
  Set<Node> getFullVerticalPath(Node node) {
    final upwardPath = getVerticalPathBetweenNodes(root, node);
    visitDepth(
      (current) {
        upwardPath.add(current);
        return VisitResult.continueVisit;
      },
      startNode: node,
    );
    return upwardPath;
  }

  /// ## Возвращает путь между двумя вершинами внутри одной "ветки".
  ///
  /// При отсутствии общего родителя возвращается пустой путь.
  @override
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
    final path = <Node>[current];

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

  /// ## Возвращает "сиблингов" (братьев и сестёр по общему родителю) для [node].
  @override
  Set<Node> getSiblings(Node node) {
    final parent = getNodeParent(node);
    if (parent != null) {
      // Возвращаем всех детей того же родителя
      return getNodeEdges(parent);
    }
    return const {};
  }

  /// ## Возвращает множество всех листьев, либо всех листьев поддерева [startNode].
  @override
  Set<Node> getLeaves({Node? startNode}) {
    final start = startNode ?? root;
    final result = <Node>{};
    visitBreadth(
      (node) {
        final nodeEdges = getNodeEdges(node);
        if (nodeEdges.isEmpty) {
          result.add(node);
        }
        return VisitResult.continueVisit;
      },
      startNode: start,
    );
    return result;
  }

  /// ## Возвращает уровень вершины [node]. Если вершина не найдена, возвращается -1.
  @override
  int getNodeLevel(Node node) {
    bool found = false;
    final level = visitBreadth(
      (n) {
        if (n == node) {
          found = true;
          return VisitResult.breakVisit;
        }
        return VisitResult.continueVisit;
      },
    );
    return found ? level : -1;
  }

  /// ## Возвращает Map<Node, int> — уровни для всех вершин.
  @override
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

  @override
  String get graphString {
    final buffer = StringBuffer();
    visitDepthBacktrack((path) {
      if (path.isNotEmpty) {
        final level = path.length - 1;
        final node = path.last;
        final data = getNodeData(node.key);
        buffer.writeln(
          '${'|  ' * level}$node${data != null ? ' [data: $data]' : ''}',
        );
      }
      return VisitResult.continueVisit;
    });
    return buffer.toString();
  }

  // ==================================
  // Вспомогательный метод проверки
  // ==================================
  void _assertNodeExists(Node node, {String extra = ''}) {
    if (!_nodes.containsKey(node.key)) {
      throw StateError('Graph does not contain the node "$node". $extra');
    }
  }
}
