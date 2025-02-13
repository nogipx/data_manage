# 🚀 Advanced Graph Utils Usage

## 🎯 Architecture

The library is built on several abstraction layers:

```
IGraphData<T>           # Base interface for data access
    ↓
IGraphEditable<T>       # Interface for graph modification
    ↓
IGraphIterable<T>       # Interface for graph iteration
    ↓
Graph<T>               # Full implementation with all features
```

The interfaces are designed to separate concerns:
- `IGraphData<T>` - Read-only access to graph structure and data
- `IGraphEditable<T>` - Mutations and graph modifications
- `IGraphIterable<T>` - Advanced traversal and iteration capabilities

## 🔄 Iterators

### Basic Iterators
```dart
// Depth-First Iterator
for (final node in graph.depthNodes) { ... }

// Breadth-First Iterator
for (final node in graph.breadthNodes) { ... }

// Level Iterator
for (final level in graph.levels) { ... }

// Leaves Iterator
for (final leaf in graph.leaves) { ... }
```

### Special Iterators
```dart
// Path Iterator
for (final node in graph.pathBetween(start, end)) { ... }

// Subtree Iterator
for (final node in graph.subtree(root)) { ... }

// Backtrack Iterator (with full path)
for (final path in graph.paths) { ... }
```

### Iterator Composition
```dart
// Filtering
final filtered = graph.filtered(
  graph.depthIterator,
  (node) => graph.getNodeData(node.key) != null
);

// Transformation
final mapped = graph.mapped(
  graph.levelIterator,
  (nodes) => nodes.length
);

// Combination
final result = graph.mapped(
  graph.filtered(
    graph.depthIterator,
    (node) => graph.getNodeData(node.key) != null
  ),
  (node) => graph.getNodeData(node.key)!
);
```

### Advanced Iterator Combinations

Итераторы можно комбинировать различными способами для решения сложных задач:

```dart
// Поиск листьев на определенном уровне
final leavesAtLevel = graph.filtered(
  graph.leavesIterator,
  (node) => graph.getNodeLevel(node) == targetLevel
);

// Обход только узлов с определенными данными
final nodesWithData = graph.filtered(
  graph.breadthIterator,
  (node) => graph.getNodeData(node.key) is SpecificType
);

// Трансформация путей в строки
final pathStrings = graph.mapped(
  graph.backtrackIterator,
  (path) => path.map((n) => n.key).join(' -> ')
);

// Сложная фильтрация с несколькими условиями
final complexFiltered = graph.filtered(
  graph.depthIterator,
  (node) {
    final parent = graph.getNodeParent(node);
    final children = graph.getNodeEdges(node);
    return parent != null && 
           children.length > 2 && 
           graph.getNodeData(node.key) != null;
  }
);

// Комбинация фильтрации и маппинга для анализа
final analysis = graph.mapped(
  graph.filtered(
    graph.levelIterator,
    (nodes) => nodes.length > 3
  ),
  (nodes) => {
    'level': graph.getNodeLevel(nodes.first),
    'count': nodes.length,
    'withData': nodes.where((n) => 
      graph.getNodeData(n.key) != null
    ).length
  }
);

// Поиск специфических паттернов в дереве
final patterns = graph.mapped(
  graph.filtered(
    graph.backtrackIterator,
    (path) => path.length >= 3 && _matchesPattern(path)
  ),
  (path) => PathPattern(
    start: path.first,
    end: path.last,
    length: path.length
  )
);
```

Такие комбинации особенно полезны для:
- Сложного анализа структуры дерева
- Поиска специфических паттернов
- Трансформации данных
- Валидации структуры
- Сбора статистики

## 🔍 Analysis Algorithms

### Structural Analysis
```dart
// Find Lowest Common Ancestor
final lca = graph.findLowestCommonAncestor(nodeA, nodeB);

// Check Balance
if (graph.isBalanced()) { ... }

// Find Central Nodes
final centers = graph.findCentralNodes();
```

### Tree Comparison
```dart
// Isomorphism Check (O(n * log n))
if (tree1.isIsomorphicTo(tree2)) { ... }

// Edit Distance (O(n²))
final distance = tree1.calculateEditDistance(tree2);
```

### Pattern Detection
```dart
// Find Repeating Subtrees (O(n * h))
final patterns = graph.findRepeatingSubtrees();

// Find Node Chains (O(n * k))
final chains = graph.findPatterns(length);
```

## 🎨 Visualization Customization

```dart
// Custom Mermaid Styles
final style = GraphStyle(
  nodeShape: 'rounded-box',
  edgeStyle: '===>',
  graphDirection: 'LR',
  showNodeData: true
);

// Generate Diagram
final diagram = graph.toMermaid(style);
```

## 🔧 Extending Functionality

### Creating Custom Iterator
```dart
class CustomIterator extends BaseGraphIterator<Node> {
  CustomIterator(super.graph);

  @override
  bool moveNext() {
    // Your implementation
  }
}
```

### Adding New Algorithms
```dart
extension GraphAlgorithms<T> on Graph<T> {
  void customAlgorithm() {
    // Your implementation
  }
}
```

## ⚡️ Performance Optimization

### Operation Complexity
- Node addition: O(1)
- Edge addition: O(1)
- Node lookup: O(1)
- DFS/BFS traversal: O(V + E)
- Path finding: O(h), where h is tree height
- Isomorphism check: O(n * log n)
- Edit distance: O(n²)

### Best Practices
1. Use `pathBetween()` instead of `getPathToNode()` for frequent operations
2. Cache `getDepths()` results if structure doesn't change
3. Avoid frequent `isBalanced()` calls on large trees
4. Use `subtree()` instead of filtering the whole tree

## 🔬 Debugging

### Structure Output
```dart
// Text representation
print(graph.graphString);

// Mermaid diagram
print(graph.toMermaid());

// Structure analysis
print(graph.analyzeStructure());
```

### Validation
```dart
// Check node existence
graph._assertNodeExists(node);

// Check for cycles
if (graph.isAncestor(child, parent)) {
  throw StateError('Cycle detected');
}
```

## 🎯 Implementation Details

### Memory Management
- All collections use efficient Dart implementations
- Immutable getters prevent accidental modifications
- Smart caching for frequently accessed data

### Thread Safety
- All operations are synchronous
- No static mutable state
- Safe to use in isolates

### Error Handling
- Clear error messages
- State validation before operations
- Proper cleanup on failures