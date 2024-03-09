import '_index.dart';

abstract class ITree<Data> implements IGraphData<Data> {
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
}
