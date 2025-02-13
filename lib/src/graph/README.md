# 🌳 Graph Utils

A powerful and flexible library for working with directed graphs in Dart/Flutter.

## ⚡️ Quick Start

```dart
// Create a graph
final graph = Graph<String>(root: Node('root'));

// Add nodes and edges
graph.addNode(Node('A'));
graph.addNode(Node('B'));
graph.addEdge(Node('root'), Node('A'));
graph.addEdge(Node('root'), Node('B'));

// Add data to nodes
graph.updateNodeData('A', 'Some data for A');
```

## 🎯 Core Features

### Basic Operations
- Add/remove nodes and edges
- Store data in nodes
- Find parents and children
- Basic graph navigation

```dart
// Basic navigation
final parent = graph.getNodeParent(node);
final children = graph.getNodeEdges(node);
final siblings = graph.getSiblings(node);
final leaves = graph.getLeaves();
```

### Iterators and Traversal
The library provides convenient iterators for graph traversal:

```dart
// Depth-first traversal
for (final node in graph.depthNodes) {
  print(node.key);
}

// Breadth-first traversal
for (final node in graph.breadthNodes) {
  print(node.key);
}

// Level-by-level traversal
for (final level in graph.levels) {
  print('Level nodes: ${level.map((n) => n.key).join(', ')}');
}
```

## 🚀 Advanced Features

### Structure Analysis
```dart
// Get graph statistics
final stats = graph.analyzeStructure();
print('Graph depth: ${stats['maxDepth']}');
print('Average branching: ${stats['averageBranching']}');
print('Total nodes: ${stats['totalNodes']}');
```

### Pattern Matching
```dart
// Find repeating subgraphs
final repeating = graph.findRepeatingSubgraphs();
for (final entry in repeating.entries) {
  print('Pattern found in nodes: ${entry.value.map((n) => n.key).join(', ')}');
}

// Find node chains
for (final pattern in graph.findPatterns(3)) {
  print('Chain: ${pattern.map((n) => n.key).join(' -> ')}');
}
```

### Graph Comparison
```dart
// Check for isomorphism
if (graph1.isIsomorphicTo(graph2)) {
  print('Graphs are structurally identical');
}

// Calculate edit distance
final distance = graph1.calculateEditDistance(graph2);
print('Need $distance operations to transform the graph');
```

## 🎨 Visualization

The library supports Mermaid diagram generation:

```dart
// Generate diagram
final diagram = graph.toMermaid(GraphStyle.roundedStyle);

// Generate HTML with diagram
final html = graph.toMermaidHtml(GraphStyle.leftToRight);
```

## 🔧 Extensibility

The library is built on interfaces, making it easy to extend:

```dart
class CustomGraph<T> extends Graph<T> {
  CustomGraph({required super.root});

  // Add your methods
  void customOperation() {
    // ...
  }
}
```

## 📦 Installation

```yaml
dependencies:
  graph_utils: ^1.0.0
```

## 🎓 Use Cases

### Organization Structure
```dart
final org = Graph<Employee>(root: Node('CEO'));
org.addEdge(Node('CEO'), Node('CTO'));
org.addEdge(Node('CEO'), Node('CFO'));
```

### File System
```dart
final fs = Graph<FileData>(root: Node('/'));
fs.addEdge(Node('/'), Node('/home'));
fs.addEdge(Node('/home'), Node('/home/user'));
```

### App Navigation
```dart
final nav = Graph<ScreenData>(root: Node('main'));
nav.addEdge(Node('main'), Node('settings'));
nav.addEdge(Node('settings'), Node('profile'));
```

## 🤝 Contributing

We're open to suggestions and improvements! Feel free to create issues and pull requests.

## 📄 License

MIT License - do whatever you want, just mention the authors 😉

## 📚 Documentation

For advanced usage and technical details, see [ADVANCED.md](ADVANCED.md)