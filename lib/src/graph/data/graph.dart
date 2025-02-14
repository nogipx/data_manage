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

  // Кэш для часто используемых вычислений
  // Не используем WeakReference, так как:
  // 1. Кэш содержит только ссылки на узлы, которые уже хранятся в графе
  // 2. Кэш инвалидируется при любом изменении структуры
  // 3. Время жизни кэша совпадает со временем жизни графа
  Map<int, Set<Node>>? _cachedLevels;
  Map<Node, int>? _cachedDepths;

  /// Инвалидирует кэш при изменении структуры графа
  void _invalidateCache() {
    _cachedLevels = null;
    _cachedDepths = null;
  }

  /// Очищает кэш для освобождения памяти
  /// Используйте этот метод, если нужно временно освободить память,
  /// например, когда граф долго не используется
  void clearCache() {
    _invalidateCache();
  }

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
    _invalidateCache();
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
    _invalidateCache();
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
    _invalidateCache();
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
      _edges[parent] = <Node>{}; // Оставляем пустой сет вместо удаления
    }
    _invalidateCache();
  }

  @override
  void clear() {
    final oldRoot = root;
    _nodes.clear();
    _nodeDataManager.clear();
    _edges.clear();
    _parents.clear();
    _invalidateCache();
    addNode(oldRoot); // Добавляем корневой узел обратно
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
    return Set.unmodifiable(_edges[node] ?? <Node>{});
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
    final levels = _getLevelsMap();
    int maxLevel = -1;

    for (final entry in levels.entries) {
      for (final node in entry.value) {
        final result = visit(node);
        if (result == VisitResult.breakVisit) {
          return entry.key;
        }
      }
      maxLevel = entry.key;
    }

    return maxLevel;
  }

  @override
  void visitDepth(VisitCallback visit, {Node? startNode}) {
    _visitDepthFirst(startNode ?? root, (node) {
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
    if (parent == null) return const {};

    return getNodeEdges(parent).where((n) => n != node).toSet();
  }

  @override
  Set<Node> getLeaves({Node? startNode}) {
    return _findLeaves();
  }

  @override
  int getNodeLevel(Node node) {
    final levels = _getLevelsMap();
    for (final entry in levels.entries) {
      if (entry.value.contains(node)) {
        return entry.key;
      }
    }
    return -1;
  }

  @override
  Map<Node, int> getDepths() {
    if (_cachedDepths != null) return _cachedDepths!;

    final result = <Node, int>{};
    final levels = _getLevelsMap();

    for (final entry in levels.entries) {
      for (final node in entry.value) {
        result[node] = entry.key;
      }
    }

    _cachedDepths = result;
    return result;
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
  Iterator<Node> subtreeIterator(Node root) => SubtreeIterator(this, root);

  @override
  Iterator<R> filtered<R>(Iterator<R> source, bool Function(R) predicate) =>
      FilteredIterator(source, predicate);

  @override
  Iterator<R> mapped<R>(Iterator<T> source, R Function(T) mapper) => MappedIterator(source, mapper);

  /// Создает Iterable для пути между узлами
  Iterable<Node> pathBetween(Node start, Node end) => _IterableGraph(pathIterator(start, end));

  /// Создает Iterable для поддерева
  Iterable<Node> subtree(Node root) => _IterableGraph(subtreeIterator(root));

  // ==================================
  // Вспомогательный метод проверки
  // ==================================
  void _assertNodeExists(Node node, {String extra = ''}) {
    if (!containsNode(node.key)) {
      throw StateError('Node "${node.key}" does not exist in graph $extra');
    }
  }

  /// Находит наименьшего общего предка для двух узлов
  Node? findLowestCommonAncestor(Node first, Node second) {
    if (first == second) return first;

    // Получаем глубины узлов для оптимизации
    final depths = getDepths();
    final firstDepth = depths[first] ?? 0;
    final secondDepth = depths[second] ?? 0;

    // Поднимаем более глубокий узел до уровня менее глубокого
    var currentFirst = first;
    var currentSecond = second;

    // Выравниваем глубину узлов
    for (var i = 0; i < (firstDepth - secondDepth); i++) {
      final parent = getNodeParent(currentFirst);
      if (parent == null) return null;
      currentFirst = parent;
    }

    for (var i = 0; i < (secondDepth - firstDepth); i++) {
      final parent = getNodeParent(currentSecond);
      if (parent == null) return null;
      currentSecond = parent;
    }

    // Если после выравнивания узлы совпали - это и есть LCA
    if (currentFirst == currentSecond) return currentFirst;

    // Поднимаемся по дереву, пока не найдем общего предка
    while (currentFirst != root && currentSecond != root) {
      final parentFirst = getNodeParent(currentFirst);
      final parentSecond = getNodeParent(currentSecond);

      if (parentFirst == null || parentSecond == null) return null;
      if (parentFirst == parentSecond) return parentFirst;

      currentFirst = parentFirst;
      currentSecond = parentSecond;
    }

    return root;
  }

  /// Проверяет, является ли один узел предком другого
  @override
  bool isAncestor({required Node ancestor, required Node descendant}) {
    return getPathToNode(descendant).contains(ancestor);
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
    final visited = <Node>{};

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (visited.contains(node)) continue;

      visited.add(node);
      if (!visitor(node)) return; // Прерываем если visitor вернул false
      stack.addAll(getNodeEdges(node).toList().reversed);
    }
  }

  /// Базовый метод обхода по уровням с колбэком для обработки узлов
  void _traverseLevels(void Function(Node node, int level) onNode) {
    final queue = Queue<_NodeWithLevel>()..add(_NodeWithLevel(root, 0));
    final visited = <Node>{};

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (visited.contains(current.node)) continue;

      visited.add(current.node);
      onNode(current.node, current.level);

      for (final child in getNodeEdges(current.node)) {
        if (!visited.contains(child)) {
          queue.add(_NodeWithLevel(child, current.level + 1));
        }
      }
    }
  }

  /// Базовый метод обхода по уровням
  Map<int, Set<Node>> _getLevelsMap() {
    if (_cachedLevels != null) return _cachedLevels!;

    final levels = <int, Set<Node>>{};
    _traverseLevels((node, level) {
      levels.putIfAbsent(level, () => {}).add(node);
    });

    _cachedLevels = levels;
    return levels;
  }

  // ==================================
  // МЕТОДЫ ДОСТУПА К СТРУКТУРЕ
  // ==================================

  /// Возвращает все листья графа
  Set<Node> _findLeaves() {
    final result = <Node>{};
    _visitDepthFirst(root, (node) {
      if (getNodeEdges(node).isEmpty) {
        result.add(node);
      }
      return true; // Продолжаем обход
    });
    return result;
  }

  /// Возвращает поддерево с корнем в node
  Set<Node> _getSubtree(Node node) {
    final result = <Node>{};
    _visitDepthFirst(node, (n) {
      result.add(n);
      return true; // Продолжаем обход
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
    final result = <Node>{};

    // Находим LCA
    final commonAncestor = findLowestCommonAncestor(first, second);
    if (commonAncestor == null) return {};

    // Добавляем путь от first до LCA
    var current = first;
    while (current != commonAncestor) {
      result.add(current);
      final parent = getNodeParent(current);
      if (parent == null) return {};
      current = parent;
    }

    // Добавляем LCA
    result.add(commonAncestor);

    // Добавляем путь от second до LCA
    current = second;
    while (current != commonAncestor) {
      result.add(current);
      final parent = getNodeParent(current);
      if (parent == null) return {};
      current = parent;
    }

    return result;
  }

  @override
  Set<Node> getPathToNode(Node node) {
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
  final Iterator<T> _iterator;
  _IterableGraph(this._iterator);

  @override
  Iterator<T> get iterator => _iterator;
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
