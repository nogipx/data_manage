import '../_index.dart';

abstract interface class IGraph<Data> implements IGraphData<Data> {
  IGraphEditable<Data> selectRoot(String key);

  Map<Node, int> getDepths();

  Set<Node> getFullVerticalPath(Node node);

  Set<Node> getLeaves({Node? startNode});

  bool containsNode(String nodeKey);

  Node? getNodeByKey(String key);

  Data? getNodeData(String key);

  Set<Node> getNodeEdges(Node node);

  int getNodeLevel(Node node);

  Node? getNodeParent(Node node);

  Set<Node> getPathToNode(Node node);

  Set<Node> getSiblings(Node node);

  Set<Node> getVerticalPathBetweenNodes(
    Node first,
    Node second, {
    Map<String, int>? depths,
  });

  int visitBreadth(VisitCallback visit, {Node? startNode});

  void visitDepth(VisitCallback visit, {Node? startNode});

  void visitDepthBacktrack(BacktrackCallback visit);

  bool isAncestor({required Node ancestor, required Node descendant});
}

abstract interface class IGraphData<T> {
  Node get root;

  Map<Node, Set<Node>> get edges;

  Map<String, T> get nodeData;

  Map<String, Node> get nodes;

  Map<Node, Node> get parents;

  String get graphString;
}

abstract interface class IGraphEditable<Data> implements IGraphData<Data>, IGraph<Data> {
  void addEdge(Node first, Node second);

  void addNode(Node node);

  void clear();

  void removeEdge(Node first, Node second);

  void removeNode(Node node);

  void updateNodeData(String key, Data data);
}

/// Интерфейс для итерации по графу
abstract interface class IGraphIterable<T> {
  /// Итератор для обхода в глубину
  Iterator<Node> get depthIterator;

  /// Итератор для обхода в ширину
  Iterator<Node> get breadthIterator;

  /// Итератор для обхода листьев
  Iterator<Node> get leavesIterator;

  /// Итератор по уровням (возвращает Set<Node> для каждого уровня)
  Iterator<Set<Node>> get levelIterator;

  /// Создает итератор для обхода пути между узлами
  Iterator<Node> pathIterator(Node start, Node end);

  /// Создает итератор для обхода поддерева
  Iterator<Node> subtreeIterator(Node root);

  /// Создает фильтрованный итератор
  Iterator<R> filtered<R>(Iterator<R> source, bool Function(R) predicate);

  /// Создает итератор с трансформацией
  Iterator<R> mapped<R>(Iterator<T> source, R Function(T) mapper);

  /// Создает итератор для обхода с backtracking
  Iterator<List<Node>> get backtrackIterator;
}
