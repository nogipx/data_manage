import 'dart:collection';

import 'package:data_manage/src/graph/_index.dart';

import 'node_data_managers/_index.dart';
part 'subtree_view.dart';

class Graph<T> implements IGraph<T>, IGraphEditable<T>, IGraphIterable<T> {
  @override
  final Node root;

  @override
  Map<String, Node> get nodes => Map.unmodifiable(_nodes);
  final Map<String, Node> _nodes = {};

  @override
  Map<String, T> get nodeData => _nodeDataManager.data;
  final INodeDataManager<T> _nodeDataManager;

  @override
  Map<Node, Set<Node>> get edges => Map.unmodifiable(_edges);
  final Map<Node, Set<Node>> _edges = {};

  @override
  Map<Node, Node> get parents => Map.unmodifiable(_parents);
  final Map<Node, Node> _parents = {};


  Graph({
    required this.root,
    Map<String, Node> nodes = const {},
    Map<String, T> nodesData = const {},
    Map<Node, Set<Node>> edges = const {},
    Map<Node, Node> parents = const {},
    INodeDataManager<T>? nodeDataManager,
  }) : _nodeDataManager = nodeDataManager ?? SimpleNodeDataManager<T>() {
    addNode(root);
    _nodes.addAll(nodes);
    nodesData.forEach(_nodeDataManager.set);
    _edges.addAll(edges);
    _parents.addAll(parents);

    if (_edges.isNotEmpty || _parents.isNotEmpty) {
      analyzeIntegrity(repair: true);
    }
  }

  // ==================================
  // ADD OPERATIONS
  // ==================================

  @override
  void addNode(Node node) {
    if (node.key.isEmpty) {
      throw ArgumentError('Cannot add node with empty key');
    }
    if (containsNode(node.key)) {
      if (node == root) return; // Разрешаем повторное добавление корневого узла
      throw StateError('Graph already contains node "${node.key}"');
    }
    _nodes[node.key] = node;
  }

  @override
  void addEdge(Node parent, Node child) {
    if (parent == child) {
      throw StateError('Cannot add self-referencing edge');
    }

    if (!containsNode(parent.key)) {
      addNode(parent);
    }
    if (!containsNode(child.key)) {
      addNode(child);
    }

    final existingParent = getNodeParent(child);
    if (existingParent != null) {
      throw StateError(
        'Node "${child.key}" already has a parent "${existingParent.key}"',
      );
    }

    // Проверяем, не создаст ли новое ребро цикл
    if (_wouldCreateCycle(parent, child)) {
      throw StateError('Cannot create cycle');
    }

    _parents[child] = parent;
    final childSet = _edges.putIfAbsent(parent, () => <Node>{});
    childSet.add(child);
  }

  bool _wouldCreateCycle(Node parent, Node child) {
    // Проверяем, не является ли child предком parent
    Node? current = parent;
    while (current != null) {
      if (current == child) return true;
      current = getNodeParent(current);
    }
    return false;
  }

  // ==================================
  // REMOVE OPERATIONS
  // ==================================

  @override
  void removeNode(Node node) {
    if (!containsNode(node.key)) {
      throw StateError('Node "${node.key}" does not exist in graph');
    }
    if (node == root) {
      throw StateError('Root node cannot be removed');
    }

    // Сначала удаляем все рёбра, связанные с узлом
    final nodeEdges = getNodeEdges(node).toList();
    for (final child in nodeEdges) {
      removeEdge(node, child);
    }

    // Удаляем узел из родительских связей
    final parent = getNodeParent(node);
    if (parent != null) {
      removeEdge(parent, node);
    }

    // Удаляем сам узел
    _nodes.remove(node.key);
    _edges.remove(node);
    _nodeDataManager.remove(node.key);
  }

  @override
  void removeEdge(Node parent, Node child) {
    if (!containsNode(parent.key)) {
      throw StateError('Node "${parent.key}" does not exist in graph (parent)');
    }
    if (!containsNode(child.key)) {
      throw StateError('Node "${child.key}" does not exist in graph (child)');
    }

    if (!_edges.containsKey(parent) || !_edges[parent]!.contains(child)) {
      throw StateError('Edge between "${parent.key}" and "${child.key}" does not exist');
    }

    _parents.remove(child);
    final childSet = _edges[parent]!;
    childSet.remove(child);
    if (childSet.isEmpty) {
      _edges[parent] = <Node>{};
    }
  }

  @override
  void clear() {
    final oldRoot = root;
    _nodes.clear();
    _nodeDataManager.clear();
    _edges.clear();
    _parents.clear();
    addNode(oldRoot);
  }

  // ==================================
  // EXTRA DATA OPERATIONS
  // ==================================

  @override
  T? getNodeData(String key) => _nodeDataManager.get(key);

  @override
  void updateNodeData(String key, T data) {
    if (!containsNode(key)) {
      throw StateError('Cannot update data for non-existent node "$key"');
    }
    _nodeDataManager.set(key, data);
  }

  /// Получить метрики использования кэша данных
  Map<String, dynamic> getDataCacheMetrics() => _nodeDataManager.getMetrics();

  // ==================================
  // ACCESS OPERATIONS
  // ==================================

  @override
  Node? getNodeByKey(String key) {
    if (key.isEmpty) {
      throw ArgumentError('Cannot get node with empty key');
    }
    return _nodes[key];
  }

  @override
  bool containsNode(String nodeKey) => _nodes.containsKey(nodeKey);

  @override
  Node? getNodeParent(Node node) => _parents[node];

  @override
  Set<Node> getNodeEdges(Node node) {
    if (!containsNode(node.key)) {
      throw StateError('Node "${node.key}" does not exist in graph');
    }
    final children = _edges[node];
    if (children == null || children.isEmpty) {
      return const <Node>{};
    }
    return Set.unmodifiable(children);
  }

  Map<Node, Set<Node>> get edgesWithEmptySets {
    // Создаем копию с пустыми сетами для узлов без рёбер
    final result = Map<Node, Set<Node>>.fromEntries(
      nodes.values.map((node) => MapEntry(node, _edges[node] ?? <Node>{})),
    );
    return Map.unmodifiable(result);
  }

  // ==================================
  // METHODS
  // ==================================

  @override
  IGraphEditable<T> extractSubtree(String key, {bool copy = true}) {
    _assertNodeExists(Node(key));
    final newRoot = getNodeByKey(key)!;

    if (!copy) {
      // Возвращаем view на существующий граф
      return SubtreeView<T>(
        originalGraph: this,
        subtreeRoot: newRoot,
      );
    }

    // Создаем копию поддерева
    final tree = Graph<T>(root: newRoot);
    final subtree = _getSubtree(newRoot);

    for (final node in subtree) {
      if (node != newRoot) {
        tree.addNode(node);
      }

      final parent = getNodeParent(node);
      if (parent != null && subtree.contains(parent)) {
        tree.addEdge(parent, node);
      }

      final data = getNodeData(node.key);
      if (data != null) {
        tree.updateNodeData(node.key, data);
      }
    }

    return tree;
  }

  @override
  int visitBreadth(VisitCallback visit, {Node? startNode}) {
    final origin = startNode ?? root;
    _assertNodeExists(origin, extra: '(start node)');

    final queue = Queue<_NodeWithLevel>()..add(_NodeWithLevel(origin, 0));
    final visited = <Node>{};
    var lastLevel = -1;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (visited.contains(current.node)) continue;

      visited.add(current.node);
      lastLevel = current.level;

      final result = visit(current.node);
      if (result == VisitResult.breakVisit) {
        return current.level;
      }

      for (final child in getNodeEdges(current.node)) {
        if (!visited.contains(child)) {
          queue.add(_NodeWithLevel(child, current.level + 1));
        }
      }
    }

    return lastLevel;
  }

  @override
  void visitDepth(VisitCallback visit, {Node? startNode}) {
    final origin = startNode ?? root;
    _assertNodeExists(origin, extra: '(start node)');

    _visitDepthFirst(origin, (node) {
      final result = visit(node);
      return result != VisitResult.breakVisit;
    });
  }

  @override
  void visitDepthBacktrack(BacktrackCallback visit) {
    final paths = _getAllPaths();
    for (final path in paths) {
      final result = visit(path);
      if (result == VisitResult.breakVisit) break;
    }
  }

  @override
  Set<Node> getSiblings(Node node) {
    final parent = getNodeParent(node);
    if (parent == null) return const <Node>{};

    return getNodeEdges(parent).where((n) => n != node).toSet();
  }

  @override
  Set<Node> getLeaves({Node? startNode}) {
    final origin = startNode ?? root;
    _assertNodeExists(origin, extra: '(start node)');
    return _findLeaves(origin);
  }

  @override
  int getNodeLevel(Node node) {
    int level = 0;
    var current = getNodeParent(node);
    while (current != null) {
      level++;
      current = getNodeParent(current);
    }
    return level;
  }

  @override
  Map<Node, int> getDepths() {
    final result = <Node, int>{};
    final queue = Queue<Node>()..add(root);
    while (queue.isNotEmpty) {
      final node = queue.removeFirst();
      final parent = _parents[node];
      result[node] = parent == null ? 0 : result[parent]! + 1;
      final children = _edges[node];
      if (children != null) queue.addAll(children);
    }
    return Map.unmodifiable(result);
  }

  @override
  String get graphString {
    final buffer = StringBuffer();

    for (final path in _getAllPaths()) {
      final level = path.length - 1;
      final node = path.last;
      final data = getNodeData(node.key);
      buffer.writeln(
        '${'|  ' * level}$node${data != null ? ' [data: $data]' : ''}',
      );
    }

    return buffer.toString();
  }

  // ==================================
  // ITERATORS
  // ==================================

  @override
  Iterator<Node> get depthIterator => DepthFirstIterator(this);

  @override
  Iterator<Node> get breadthIterator => BreadthFirstIterator(this);

  @override
  Iterator<Node> get leavesIterator => LeavesIterator(this);

  @override
  Iterator<Set<Node>> get levelIterator => LevelIterator(this);

  @override
  Iterator<List<Node>> get backtrackIterator => BacktrackIterator(this);

  @override
  Iterator<Node> pathIterator(Node start, Node end) => PathIterator(this, start, end);

  @override
  Iterator<Node> subtreeIterator(Node root) {
    _assertNodeExists(root, extra: '(subtree root)');
    return SubtreeIterator(this, root);
  }

  @override
  Iterator<R> filtered<R>(Iterator<R> source, bool Function(R) predicate) =>
      FilteredIterator(source, predicate);

  @override
  Iterator<R> mapped<R>(Iterator<T> source, R Function(T) mapper) => MappedIterator(source, mapper);

  /// Создает Iterable для пути между узлами
  Iterable<Node> pathBetween(Node start, Node end) {
    _assertNodeExists(start, extra: '(path start)');
    _assertNodeExists(end, extra: '(path end)');
    return _IterableGraph(() => pathIterator(start, end));
  }

  /// Создает Iterable для поддерева
  Iterable<Node> subtree(Node root) {
    _assertNodeExists(root, extra: '(subtree root)');
    return _IterableGraph(() => subtreeIterator(root));
  }

  // ==================================
  // Вспомогательный метод проверки
  // ==================================
  void _assertNodeExists(Node node, {String extra = ''}) {
    if (!containsNode(node.key)) {
      throw StateError('Node "${node.key}" does not exist in graph $extra');
    }
  }

  void _removeParentLinkForKey(String childKey, {Node? expectedParent}) {
    if (_parents.isEmpty) return;
    _parents.removeWhere((child, parent) {
      if (child.key != childKey) return false;
      if (expectedParent == null) return true;
      return parent.key == expectedParent.key;
    });
  }

  /// Находит наименьшего общего предка для двух узлов
  Node? findLowestCommonAncestor(Node first, Node second) {
    if (first == second) return first;

    // Собираем всех предков first (включая его самого)
    final ancestors = <Node>{};
    var current = first;
    while (true) {
      ancestors.add(current);
      final parent = getNodeParent(current);
      if (parent == null) break;
      current = parent;
    }

    // Идём вверх от second — первый узел из ancestors и есть LCA
    current = second;
    while (true) {
      if (ancestors.contains(current)) return current;
      final parent = getNodeParent(current);
      if (parent == null) return null;
      current = parent;
    }
  }

  /// Проверяет, является ли один узел предком другого
  @override
  bool isAncestor({required Node ancestor, required Node descendant}) {
    var current = getNodeParent(descendant);
    while (current != null) {
      if (current == ancestor) return true;
      current = getNodeParent(current);
    }
    return false;
  }

  // ==================================
  // БАЗОВЫЕ МЕТОДЫ ОБХОДА
  // ==================================

  /// Базовый метод обхода в глубину.
  ///
  /// В отличие от [DepthFirstIterator], который предоставляет публичный API для последовательного
  /// обхода дерева, этот метод используется внутри для быстрого обхода с кастомным visitor-колбэком.
  ///
  /// Такой подход эффективнее для внутренних операций, где нам не нужен полный контроль над итерацией,
  /// а нужно просто быстро пройти по всем узлам и что-то сделать (например собрать все листья или
  /// построить поддерево). В этих случаях создание итератора было бы избыточным.
  ///
  /// Если visitor возвращает false, обход прерывается.
  void _visitDepthFirst(Node start, bool Function(Node) visitor) {
    final stack = <Node>[start];

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (!containsNode(node.key)) continue;
      final children = getNodeEdges(node);
      if (!visitor(node)) return;
      for (final child in children.toList().reversed) {
        stack.add(child);
      }
    }
  }


  // ==================================
  // МЕТОДЫ ДОСТУПА К СТРУКТУРЕ
  // ==================================

  /// Возвращает все листья графа
  Set<Node> _findLeaves(Node start) {
    final result = <Node>{};
    final stack = <Node>[start];

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      final children = getNodeEdges(node);
      if (children.isEmpty) {
        result.add(node);
      } else {
        stack.addAll(children);
      }
    }

    return result;
  }

  /// Возвращает поддерево с корнем в node
  Set<Node> _getSubtree(Node node) {
    final result = <Node>{};
    _visitDepthFirst(node, (n) {
      result.add(n);
      return true;
    });
    return result;
  }

  /// Возвращает все пути от корня до листьев
  Iterable<List<Node>> _getAllPaths() sync* {
    // Всегда добавляем корневой узел как отдельный путь
    yield [root];

    final stack = <_PathNode>[
      _PathNode(root, [root])
    ];

    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      final children = getNodeEdges(current.node);

      // Добавляем текущий путь, если это не корень (который уже добавлен)
      if (current.node != root) {
        yield current.path;
      }

      for (final child in children.toList().reversed) {
        stack.add(_PathNode(child, [...current.path, child]));
      }
    }
  }

  /// Возвращает все вершины от корня до листьев, включая путь до [node].
  @override
  Set<Node> getFullVerticalPath(Node node) {
    _assertNodeExists(node);
    final result = <Node>{};
    // Добавляем путь от корня до node
    var current = node;
    while (current != root) {
      result.add(current);
      final parent = getNodeParent(current);
      if (parent == null) break;
      current = parent;
    }
    result.add(root);

    // Добавляем все узлы поддерева
    final queue = Queue<Node>()..add(node);
    while (queue.isNotEmpty) {
      current = queue.removeFirst();
      result.add(current);
      queue.addAll(getNodeEdges(current));
    }

    return result;
  }

  /// Возвращает путь между двумя вершинами внутри одной "ветки".
  ///
  /// При отсутствии общего родителя возвращается пустой путь.
  @override
  Set<Node> getVerticalPathBetweenNodes(
    Node first,
    Node second, {
    Map<String, int>? depths,
  }) {
    _assertNodeExists(first, extra: '(first node)');
    _assertNodeExists(second, extra: '(second node)');

    final result = <Node>{};

    // Находим LCA
    final commonAncestor = findLowestCommonAncestor(first, second);
    if (commonAncestor == null) return <Node>{};

    // Добавляем путь от first до LCA
    var current = first;
    while (current != commonAncestor) {
      result.add(current);
      final parent = getNodeParent(current);
      if (parent == null) return <Node>{};
      current = parent;
    }

    // Добавляем LCA
    result.add(commonAncestor);

    // Добавляем путь от second до LCA
    current = second;
    while (current != commonAncestor) {
      result.add(current);
      final parent = getNodeParent(current);
      if (parent == null) return <Node>{};
      current = parent;
    }

    return result;
  }

  @override
  List<Node> getPathBetweenNodes(Node start, Node end) {
    _assertNodeExists(start, extra: '(start node)');
    _assertNodeExists(end, extra: '(end node)');

    final lca = findLowestCommonAncestor(start, end);
    if (lca == null) return [];

    final pathToAncestor = <Node>[];
    var current = start;
    while (true) {
      pathToAncestor.add(current);
      if (current == lca) break;
      final parent = getNodeParent(current);
      if (parent == null) {
        return [];
      }
      current = parent;
    }

    final descent = <Node>[];
    current = end;
    while (current != lca) {
      descent.add(current);
      final parent = getNodeParent(current);
      if (parent == null) {
        return [];
      }
      current = parent;
    }

    return [...pathToAncestor, ...descent.reversed];
  }

  @override
  int getDistanceBetweenNodes(Node start, Node end) {
    if (start == end) return 0;

    final path = getPathBetweenNodes(start, end);
    if (path.isEmpty) return -1;

    return path.length - 1;
  }

  @override
  GraphIntegrityReport analyzeIntegrity({bool repair = false}) {
    final issues = <GraphIntegrityIssue>[];
    var mutated = false;

    final edgeEntries = _edges.entries.toList();
    for (final entry in edgeEntries) {
      final parent = entry.key;
      final children = entry.value;
      final canonicalParent = _nodes[parent.key];

      if (canonicalParent == null) {
        issues.add(
          GraphIntegrityIssue(
            type: GraphIntegrityIssueType.missingParentNode,
            node: parent,
            message:
                'Parent node "${parent.key}" is referenced in edges but missing from the graph',
          ),
        );
        if (repair) {
          for (final child in children) {
            _removeParentLinkForKey(child.key, expectedParent: parent);
          }
          _edges.remove(parent);
          mutated = true;
        }
        continue;
      }

      final sanitizedChildren = <Node>{};
      for (final child in children) {
        final canonicalChild = _nodes[child.key];
        if (canonicalChild == null) {
          issues.add(
            GraphIntegrityIssue(
              type: GraphIntegrityIssueType.missingChild,
              node: canonicalParent,
              related: child,
              message:
                  'Node "${canonicalParent.key}" references missing child "${child.key}"',
            ),
          );
          if (repair) {
            _removeParentLinkForKey(child.key, expectedParent: canonicalParent);
            mutated = true;
          }
          continue;
        }

        sanitizedChildren.add(canonicalChild);
      }

      if (repair &&
          (sanitizedChildren.length != children.length ||
              !identical(canonicalParent, parent))) {
        _edges.remove(parent);
        _edges[canonicalParent] = sanitizedChildren;
        mutated = true;
      }
    }

    final parentEntries = _parents.entries.toList();
    for (final entry in parentEntries) {
      final child = entry.key;
      final parent = entry.value;
      final canonicalChild = _nodes[child.key];
      final canonicalParent = _nodes[parent.key];

      if (canonicalChild == null) {
        issues.add(
          GraphIntegrityIssue(
            type: GraphIntegrityIssueType.missingChild,
            node: parent,
            related: child,
            message:
                'Parent "${parent.key}" keeps reference to missing child "${child.key}"',
          ),
        );
        if (repair) {
          _parents.remove(child);
          mutated = true;
        }
        continue;
      }

      if (canonicalParent == null) {
        issues.add(
          GraphIntegrityIssue(
            type: GraphIntegrityIssueType.missingParent,
            node: canonicalChild,
            related: parent,
            message:
                'Child "${canonicalChild.key}" references missing parent "${parent.key}"',
          ),
        );
        if (repair) {
          _parents.remove(child);
          mutated = true;
        }
        continue;
      }

      final childrenOfParent = _edges[canonicalParent];
      if (childrenOfParent == null || !childrenOfParent.contains(canonicalChild)) {
        issues.add(
          GraphIntegrityIssue(
            type: GraphIntegrityIssueType.inconsistentParentLink,
            node: canonicalParent,
            related: canonicalChild,
            message:
                'Parent "${canonicalParent.key}" is missing edge to "${canonicalChild.key}" while parents map references it',
          ),
        );
        if (repair) {
          _parents.remove(child);
          mutated = true;
        }
      }
    }


    return GraphIntegrityReport(issues: issues);
  }

  @override
  Set<Node> getPathToNode(Node node) {
    _assertNodeExists(node);
    final result = <Node>{};
    var current = node;

    // Идем от узла к корню, добавляя все узлы в путь
    while (current != root) {
      result.add(current);
      final parent = getNodeParent(current);
      if (parent == null) break;
      current = parent;
    }
    result.add(root);

    return result;
  }
}

/// Вспомогательный класс для создания Iterable из Iterator
class _IterableGraph<T> extends Iterable<T> {
  final Iterator<T> Function() _iteratorFactory;
  _IterableGraph(this._iteratorFactory);

  @override
  Iterator<T> get iterator => _iteratorFactory();
}

/// Вспомогательный класс для обхода по уровням
class _NodeWithLevel {
  final Node node;
  final int level;
  _NodeWithLevel(this.node, this.level);
}

/// Вспомогательный класс для хранения пути
class _PathNode {
  final Node node;
  final List<Node> path;
  _PathNode(this.node, this.path);
}
