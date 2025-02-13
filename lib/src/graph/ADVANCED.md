# 🚀 Advanced Graph Usage Guide

## 🎯 Architecture Overview

The graph implementation is built on a layered architecture with clear separation of concerns:

```
IGraphData<T>           # Base interface for data access
    ↓
IGraph<T>              # Core graph operations
    ↓
IGraphEditable<T>      # Mutable graph operations
    ↓
IGraphIterable<T>      # Advanced traversal capabilities
    ↓
Graph<T>              # Concrete implementation
```

### Interface Responsibilities

#### IGraphData<T>
```dart
// Basic structure access
Map<String, Node> get nodes;
Map<Node, Set<Node>> get edges;
Map<Node, Node> get parents;
Map<String, T> get nodeData;
```

#### IGraph<T>
```dart
// Core operations
Set<Node> getNodeEdges(Node node);
Node? getNodeParent(Node node);
Set<Node> getSiblings(Node node);
Set<Node> getLeaves({Node? startNode});
```

#### IGraphEditable<T>
```dart
// Mutation operations
void addNode(Node node);
void addEdge(Node parent, Node child);
void removeNode(Node node);
void removeEdge(Node parent, Node child);
void updateNodeData(String key, T data);
```

## 🔄 Traversal Mechanisms

### Visitor Pattern Implementation
```dart
// Visit callback type
typedef VisitCallback = VisitResult Function(Node node);

// Visit result options
enum VisitResult {
  continueVisit,
  breakVisit,
}

// Usage example
graph.visitDepth((node) {
  if (someCondition) return VisitResult.breakVisit;
  return VisitResult.continueVisit;
});
```

### Traversal Strategies

#### Depth-First Traversal
```dart
void _visitDepthFirst(Node start, bool Function(Node) visitor) {
  final stack = <Node>[start];
  final visited = <Node>{};

  while (stack.isNotEmpty) {
    final node = stack.removeLast();
    if (visited.contains(node)) continue;

    visited.add(node);
    if (!visitor(node)) return;
    stack.addAll(getNodeEdges(node).toList().reversed);
  }
}
```

#### Breadth-First Traversal
```dart
int visitBreadth(VisitCallback visit, {Node? startNode}) {
  final levels = _getLevelsMap();
  int maxLevel = -1;

  for (final entry in levels.entries) {
    for (final node in entry.value) {
      if (visit(node) == VisitResult.breakVisit) {
        return entry.key;
      }
    }
    maxLevel = entry.key;
  }

  return maxLevel;
}
```

## 🔍 Path Operations

### Path Finding Algorithms
```dart
// Get path to specific node
Set<Node> getPathToNode(Node node) {
  final result = <Node>{};
  var current = node;
  
  while (current != root) {
    result.add(current);
    final parent = getNodeParent(current);
    if (parent == null) break;
    current = parent;
  }
  result.add(root);
  
  return result;
}
```

### Lowest Common Ancestor
```dart
Node? findLowestCommonAncestor(Node first, Node second) {
  if (first == second) return first;
  
  final depths = getDepths();
  final firstDepth = depths[first] ?? 0;
  final secondDepth = depths[second] ?? 0;
  
  // Equalize depths and find LCA
  // See implementation for details
}
```

## 🎨 Performance Optimizations

### Caching Strategy
```dart
// Cache invalidation on structure changes
void _invalidateCache() {
  _cachedLevels = null;
  _cachedDepths = null;
}

// Cached computations
Map<Node, int> getDepths() {
  if (_cachedDepths != null) return _cachedDepths!;
  // Compute and cache depths
}
```

### Memory Management
- Efficient use of Sets and Maps for O(1) lookups
- Smart caching of frequently accessed data
- Proper cleanup in remove operations

### Operation Complexities
- Node/Edge operations: O(1)
- Path finding: O(h) where h is height
- Traversal: O(n) where n is node count
- Level computation: O(n)

## 📦 Node Data Management

### Available Managers

#### SimpleNodeDataManager
```dart
/// Basic implementation with direct storage
class SimpleNodeDataManager<T> implements INodeDataManager<T> {
  final Map<String, T> _data = {};
  final _metrics = _DataManagerMetrics();

  @override
  T? get(String key) {
    final value = _data[key];
    value != null ? _metrics.hit() : _metrics.miss();
    return value;
  }

  @override
  void set(String key, T data) => _data[key] = data;
  
  @override
  void remove(String key) => _data.remove(key);
}
```

#### LRUNodeDataManager
```dart
/// Manager with LRU (Least Recently Used) caching strategy
class LRUNodeDataManager<T> implements INodeDataManager<T> {
  final int maxSize;
  final _data = <String, T>{};
  final _lruList = <String>[];
  
  @override
  T? get(String key) {
    final value = _data[key];
    if (value != null) {
      // Move to most recently used
      _lruList.remove(key);
      _lruList.add(key);
    }
    return value;
  }

  @override
  void set(String key, T data) {
    if (_data.length >= maxSize && !_data.containsKey(key)) {
      // Remove least recently used
      final lru = _lruList.removeAt(0);
      _data.remove(lru);
    }
    _data[key] = data;
    _lruList.add(key);
  }
}
```

### Performance Characteristics

#### SimpleNodeDataManager
- Get/Set operations: O(1)
- Memory usage: O(n) where n is number of nodes
- Best for: Small to medium graphs with frequent access to all nodes
- No memory limits

#### LRUNodeDataManager
- Get/Set operations: O(1)
- Memory usage: O(k) where k is maxSize
- Best for: Large graphs with locality of reference
- Automatic memory management

### Metrics and Monitoring
```dart
// Get detailed cache metrics
final metrics = graph.getDataCacheMetrics();

// Available metrics
{
  'size': current_cache_size,
  'maxSize': maximum_cache_size,      // For LRU only
  'hits': cache_hits_count,
  'misses': cache_misses_count,
  'hitRate': hits_to_total_ratio,
  'utilizationRate': size_to_max_ratio // For LRU only
}
```

### Custom Implementation
```dart
class CustomNodeDataManager<T> implements INodeDataManager<T> {
  @override
  Map<String, T> get data => _yourDataStorage;

  @override
  T? get(String key) {
    // Your get implementation
  }

  @override
  void set(String key, T data) {
    // Your set implementation
  }

  @override
  void remove(String key) {
    // Your remove implementation
  }

  @override
  void clear() {
    // Your clear implementation
  }

  @override
  Map<String, dynamic> getMetrics() {
    // Your metrics implementation
  }
}
```

## �� Advanced Features

### Subtree Extraction
```dart
IGraphEditable<T> extractSubtree(String key, {bool copy = true}) {
  if (!copy) {
    return _SubtreeView<T>(
      originalGraph: this,
      subtreeRoot: getNodeByKey(key)!,
    );
  }
  // Create new graph copy
}
```

### Multiple Parents Support
```dart
Graph<T>({
  bool allowManyParents = false,
}) {
  // Enables DAG-like structures
}
```

## 🎯 Best Practices

### Structure Modification
```dart
// Always check existence
void addEdge(Node parent, Node child) {
  if (!containsNode(parent.key)) {
    addNode(parent);
  }
  // ... rest of implementation
}

// Proper cleanup
void removeNode(Node node) {
  _nodes.remove(node.key);
  _edges.remove(node);
  for (final edges in _edges.values) {
    edges.remove(node);
  }
  // ... rest of cleanup
}
```

### Error Handling
```dart
void _assertNodeExists(Node node, {String extra = ''}) {
  if (!_nodes.containsKey(node.key)) {
    throw StateError('Graph does not contain the node "$node". $extra');
  }
}
```

## 📚 Implementation Notes

### Thread Safety
- All operations are synchronous
- No shared mutable state
- Safe for use in isolates

### Extension Points
- Custom node data managers
- Traversal strategy extensions
- View implementations

For implementation details, see the source code documentation.