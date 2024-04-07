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
    addNode(root);
    _nodes.addAll(nodes);
    _nodeData.addAll(nodesData);
    _edges.addAll(edges);
    _parents.addAll(parents);
  }

  // ADD OPERATIONS

  @override
  void addNode(Node node) {
    if (containsNode(node.key)) {
      throw Exception('Tree already contains node "${node.key}"');
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

    final existedParent = getNodeParent(child);
    if (!allowManyParents && existedParent != null) {
      throw Exception(
        'Node "${child.key}" already have parent "${existedParent.key}"',
      );
    }

    _parents[child] = parent;

    final firstEdges = _edges.putIfAbsent(parent, () => {});
    firstEdges.add(child);
  }

  // REMOVE OPERATIONS

  @override
  void removeNode(Node node) {
    _guardGraphContainsNode(node);
    _nodes.remove(node.key);
    _edges.remove(node) ?? {};
    for (final edges in _edges.values) {
      edges.remove(node);
    }
    _parents.remove(node);
    _parents.removeWhere((key, value) => value == node);
  }

  @override
  void removeEdge(Node parent, Node child) {
    _guardGraphContainsNode(parent, extra: '(parent)');
    _guardGraphContainsNode(child, extra: '(child)');

    _parents.remove(child);

    final firstEdges = _edges.putIfAbsent(parent, () => {});
    firstEdges.remove(child);
    if (firstEdges.isEmpty) {
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

  // EXTRA DATA OPERATIONS

  @override
  T? getNodeData(String key) => _nodeData[key];

  @override
  void updateNodeData(String key, T data) => _nodeData[key] = data;

  // ACCESS OPERATIONS

  @override
  Node? getNodeByKey(String key) => _nodes[key];

  @override
  bool containsNode(String nodeKey) => _nodes.containsKey(nodeKey);

  @override
  Node? getNodeParent(Node node) => _parents[node];

  @override
  Set<Node> getNodeEdges(Node node) => _edges[node] ?? {};

  // METHODS

  @override
  IGraphEditable<T> selectRoot(String key) {
    _guardGraphContainsNode(Node(key));
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
  /// Walk by nodes levels and returns level
  /// of tree where visit stopped.
  @override
  int visitBreadth(VisitCallback visit, {Node? startNode}) {
    final visited = <Node, bool>{};
    final queue = [startNode ?? root];
    int level = -1;

    while (queue.isNotEmpty) {
      int levelSize = queue.length;
      level++;

      while (levelSize-- != 0) {
        final node = queue.removeAt(0);

        if (visited[node] == true) {
          continue;
        }

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

  /// ## Depth-first search (DFS)
  @override
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

  /// ## Recursive depth-first search with backtracking.
  @override
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

  /// ## Returns a list of all connected vertices from the given one.
  /// From the root to the specified vertex.
  @override
  Set<Node> getPathToNode(Node node) {
    return getVerticalPathBetweenNodes(root, node);
  }

  /// ## Returns a list of all connected vertices from the given one.
  /// From the root to the leaves.
  @override
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

  /// ## Returns the path between two vertices within a subtree.
  ///
  /// Determines which vertex is higher.
  /// Then moves up the graph until reaching the parent vertex.
  /// ---
  /// If during the process the parent vertex is not found
  /// (for example, the root has no parents),
  /// it stops and returns an empty path.
  /// ---
  /// Pre-calculated depths of vertices can be passed.
  /// If pre-calculated depths are not passed,
  /// the depth for each vertex is computed.
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

  /// ## Returns a list of children of the parent of the given vertex.
  @override
  Set<Node> getSiblings(Node node) {
    final parent = getNodeParent(node);

    if (parent != null) {
      final siblings = getNodeEdges(parent);
      return siblings;
    }

    return const {};
  }

  /// ## Returns a list of leaves.
  ///
  /// If [startNode] is specified, it returns a list of leaves
  /// for which [startNode] is the common ancestor.
  ///
  /// If [startNode] is not specified, it returns
  /// a list of all leaves in the tree.
  @override
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

  /// ## Returns the depth of the specified vertex.
  ///
  /// Performs a breadth-first search to find the vertex.
  /// Upon finding a match, it stops the search
  /// and returns the depth of the vertex.
  @override
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

  /// ## Returns the depth of all vertices in the graph.
  ///
  /// Performs a traversal considering the reverse path.
  /// Saves the depth of each vertex.
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
        final msg =
            '${'|  ' * level}$node ${data != null ? '[data: $data]' : ''}';
        buffer.writeln(msg);
      }
      return VisitResult.continueVisit;
    });

    return buffer.toString();
  }

  void _guardGraphContainsNode(Node node, {String extra = ''}) {
    if (!_nodes.containsKey(node.key)) {
      throw Exception('Graph does not contains $node. $extra');
    }
  }
}
