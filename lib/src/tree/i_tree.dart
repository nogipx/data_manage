import '_index.dart';

enum VisitResult {
  continueVisit,
  breakVisit,
}

typedef VisitCallback<T> = VisitResult Function(Node node);
typedef BacktrackCallback<T> = VisitResult Function(List<Node> path);

abstract class Tree<T> {
  Node get root;

  Map<Node, Set<Node>> get edges;

  Map<String, T> get nodeData;

  Map<String, Node> get nodes;

  Map<Node, Node> get parents;

  String get graphString;
}

abstract class TreeEditable<Data> implements Tree<Data>, TreeReadable<Data> {
  void addEdge(Node first, Node second);

  void addNode(Node node);

  void clear();

  void removeEdge(Node first, Node second);

  void removeNode(Node node);

  void updateNodeData(String key, Data data);
}

abstract class TreeReadable<Data> implements Tree<Data> {
  TreeEditable<Data> selectRoot(String key);

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
}
