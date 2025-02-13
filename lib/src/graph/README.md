# 🌳 Graph Implementation

A robust and efficient implementation of directed graph data structure in Dart, with focus on tree-like structures.

## ⚡️ Quick Start

```dart
// Create a graph with root node
final graph = Graph<String>(root: Node('root'));

// Add nodes and build structure
final nodeA = Node('A');
final nodeB = Node('B');
graph.addEdge(graph.root, nodeA);
graph.addEdge(graph.root, nodeB);

// Add data to nodes
graph.updateNodeData('A', 'Node A Data');

// Work with subtrees
final subtreeView = graph.extractSubtree('A', copy: false);
subtreeView.addNode(Node('C'));
subtreeView.addEdge(subtreeView.root, Node('C'));
```

## 🎯 Core Features

### Graph Structure Operations
```dart
// Basic structure manipulation
graph.addNode(Node('C'));
graph.addEdge(nodeA, Node('C'));
graph.removeNode(nodeB);
graph.removeEdge(nodeA, nodeC);

// Structure queries
final parent = graph.getNodeParent(nodeA);
final children = graph.getNodeEdges(nodeA);
final siblings = graph.getSiblings(nodeA);
final leaves = graph.getLeaves();
```

### Traversal Methods
The graph supports multiple traversal strategies:

```dart
// Depth-first traversal
graph.visitDepth((node) {
  print(node.key);
  return VisitResult.continueVisit;
});

// Breadth-first traversal
graph.visitBreadth((node) {
  print(node.key);
  return VisitResult.continueVisit;
});

// Backtracking traversal
graph.visitDepthBacktrack((path) {
  print('Path: ${path.map((n) => n.key).join(' -> ')}');
  return VisitResult.continueVisit;
});
```

### Path Finding
```dart
// Get path to specific node
final pathToNode = graph.getPathToNode(targetNode);

// Get path between nodes
final path = graph.getVerticalPathBetweenNodes(nodeA, nodeB);

// Get full vertical path (including subtree)
final fullPath = graph.getFullVerticalPath(nodeA);
```

### Node Data Management
```dart
// Update node data
graph.updateNodeData('A', 'Updated data');

// Get node data
final data = graph.getNodeData('A');

// Clear all data
graph.clear();
```

### Node Data Managers
The graph supports different strategies for managing node data:

```dart
// Simple manager (default)
final graph = Graph<String>(
  root: Node('root'),
  nodeDataManager: SimpleNodeDataManager<String>(),
);

// LRU Cache manager
final graph = Graph<String>(
  root: Node('root'),
  nodeDataManager: LRUNodeDataManager<String>(maxSize: 100),
);

// Get cache metrics
final metrics = graph.getDataCacheMetrics();
print('Cache hits: ${metrics['hits']}');
print('Cache misses: ${metrics['misses']}');
print('Hit rate: ${metrics['hitRate']}');
```

## 🎨 Implementation Details

### Graph Properties
- Directed graph structure with strict tree hierarchy
- Single-parent relationship enforcement
- Efficient node data management
- Cached computations for performance
- Thread-safe operations

### Performance Considerations
- O(1) for most basic operations
- Cached levels and depths
- Efficient traversal implementations
- Smart memory management

## 📦 Installation

```yaml
dependencies:
  data_manage: ^2.2.1
```

## 🔧 Advanced Usage

For advanced features and detailed API documentation, see [ADVANCED.md](ADVANCED.md)

## 📄 License

MIT License