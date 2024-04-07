import '_index.dart';

abstract class IGraphData<T> {
  Node get root;

  Map<Node, Set<Node>> get edges;

  Map<String, T> get nodeData;

  Map<String, Node> get nodes;

  Map<Node, Node> get parents;

  String get graphString;
}

abstract class IGraphEditable<Data> implements IGraphData<Data>, IGraph<Data> {
  void addEdge(Node first, Node second);

  void addNode(Node node);

  void clear();

  void removeEdge(Node first, Node second);

  void removeNode(Node node);

  void updateNodeData(String key, Data data);
}
