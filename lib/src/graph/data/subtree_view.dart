part of 'graph.dart';

/// Представляет собой view на поддерево существующего графа.
///
/// View позволяет работать с частью графа как с отдельным графом,
/// при этом все изменения отражаются в оригинальном графе.
/// Операции ограничены только узлами, которые принадлежат поддереву.
///
/// Пример использования:
/// ```dart
/// final graph = Graph<String>(root: Node('root'));
/// // ... добавление узлов и ребер
///
/// // Создаем view на поддерево
/// final subtreeView = graph.extractSubtree('node1', copy: false);
///
/// // Работаем только с поддеревом
/// subtreeView.addNode(Node('new_node'));
/// subtreeView.addEdge(subtreeView.root, Node('new_node'));
/// ```
class SubtreeView<T> implements IGraphEditable<T> {
  final Graph<T> originalGraph;
  final Node subtreeRoot;
  final Set<Node> _subtreeNodes;

  SubtreeView({
    required this.originalGraph,
    required this.subtreeRoot,
  }) : _subtreeNodes = originalGraph._getSubtree(subtreeRoot);

  @override
  Node get root => subtreeRoot;

  @override
  Map<String, Node> get nodes {
    return Map.fromEntries(
      _subtreeNodes.map((node) => MapEntry(node.key, node)),
    );
  }

  @override
  Map<String, T> get nodeData {
    return Map.fromEntries(
      _subtreeNodes.map((node) {
        final data = originalGraph.getNodeData(node.key);
        return data != null ? MapEntry(node.key, data) : null;
      }).whereType<MapEntry<String, T>>(),
    );
  }

  @override
  Map<Node, Set<Node>> get edges {
    return Map.fromEntries(
      _subtreeNodes.map((node) {
        final children = originalGraph.getNodeEdges(node);
        return MapEntry(node, children.intersection(_subtreeNodes));
      }).where((entry) => entry.value.isNotEmpty),
    );
  }

  @override
  Map<Node, Node> get parents {
    return Map.fromEntries(
      _subtreeNodes.map((node) {
        final parent = originalGraph.getNodeParent(node);
        return parent != null && _subtreeNodes.contains(parent) ? MapEntry(node, parent) : null;
      }).whereType<MapEntry<Node, Node>>(),
    );
  }

  @override
  void addNode(Node node) => originalGraph.addNode(node);

  @override
  void addEdge(Node parent, Node child) {
    if (!_subtreeNodes.contains(parent)) {
      throw StateError('Parent node "${parent.key}" is not in the subtree');
    }
    originalGraph.addEdge(parent, child);
    // Обновляем множество узлов поддерева после добавления
    _subtreeNodes.add(child);
  }

  @override
  void removeNode(Node node) {
    if (!_subtreeNodes.contains(node)) {
      throw StateError('Node "${node.key}" is not in the subtree');
    }
    originalGraph.removeNode(node);
    _subtreeNodes.remove(node);
  }

  @override
  void removeEdge(Node parent, Node child) {
    if (!_subtreeNodes.contains(parent) || !_subtreeNodes.contains(child)) {
      throw StateError('One or both nodes are not in the subtree');
    }
    originalGraph.removeEdge(parent, child);
  }

  @override
  void clear() {
    for (final node in List<Node>.from(_subtreeNodes)) {
      removeNode(node);
    }
  }

  @override
  void updateNodeData(String key, T data) {
    final node = originalGraph.getNodeByKey(key);
    if (node == null || !_subtreeNodes.contains(node)) {
      throw StateError('Node "$key" is not in the subtree');
    }
    originalGraph.updateNodeData(key, data);
  }

  @override
  T? getNodeData(String key) {
    final node = originalGraph.getNodeByKey(key);
    if (node == null || !_subtreeNodes.contains(node)) return null;
    return originalGraph.getNodeData(key);
  }

  @override
  bool containsNode(String nodeKey) {
    final node = originalGraph.getNodeByKey(nodeKey);
    return node != null && _subtreeNodes.contains(node);
  }

  @override
  Node? getNodeByKey(String key) {
    final node = originalGraph.getNodeByKey(key);
    return node != null && _subtreeNodes.contains(node) ? node : null;
  }

  @override
  Set<Node> getNodeEdges(Node node) {
    if (!_subtreeNodes.contains(node)) return {};
    return originalGraph.getNodeEdges(node).intersection(_subtreeNodes);
  }

  @override
  Node? getNodeParent(Node node) {
    if (!_subtreeNodes.contains(node)) return null;
    final parent = originalGraph.getNodeParent(node);
    return parent != null && _subtreeNodes.contains(parent) ? parent : null;
  }

  @override
  Set<Node> getSiblings(Node node) {
    if (!_subtreeNodes.contains(node)) return {};
    return originalGraph.getSiblings(node).intersection(_subtreeNodes);
  }

  @override
  Set<Node> getLeaves({Node? startNode}) {
    if (startNode != null && !_subtreeNodes.contains(startNode)) return {};
    return originalGraph.getLeaves(startNode: startNode).intersection(_subtreeNodes);
  }

  @override
  String get graphString => originalGraph.graphString;

  // Делегируем остальные методы оригинальному графу
  @override
  int getNodeLevel(Node node) => originalGraph.getNodeLevel(node);

  @override
  Map<Node, int> getDepths() => originalGraph.getDepths();

  @override
  Set<Node> getFullVerticalPath(Node node) => originalGraph.getFullVerticalPath(node);

  @override
  Set<Node> getVerticalPathBetweenNodes(Node first, Node second, {Map<String, int>? depths}) =>
      originalGraph.getVerticalPathBetweenNodes(first, second, depths: depths);

  @override
  Set<Node> getPathToNode(Node node) => originalGraph.getPathToNode(node);

  @override
  bool isAncestor({required Node ancestor, required Node descendant}) =>
      originalGraph.isAncestor(ancestor: ancestor, descendant: descendant);

  @override
  int visitBreadth(VisitCallback visit, {Node? startNode}) =>
      originalGraph.visitBreadth(visit, startNode: startNode);

  @override
  void visitDepth(VisitCallback visit, {Node? startNode}) =>
      originalGraph.visitDepth(visit, startNode: startNode);

  @override
  void visitDepthBacktrack(BacktrackCallback visit) => originalGraph.visitDepthBacktrack(visit);

  @override
  IGraphEditable<T> extractSubtree(String key, {bool copy = true}) =>
      originalGraph.extractSubtree(key, copy: copy);
}
