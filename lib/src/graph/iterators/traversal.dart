import 'dart:collection';
import '../_index.dart';

/// Итератор для обхода графа в глубину
class DepthFirstIterator extends BaseNodeIterator {
  final List<Node> _stack = [];

  DepthFirstIterator(super.graph) {
    _stack.add(graph.root);
  }

  @override
  bool moveNext() {
    if (_stack.isEmpty) return false;
    final node = _stack.removeLast();
    setCurrent(node);
    final children = graph.getNodeEdges(node).toList();
    for (var i = children.length - 1; i >= 0; i--) {
      _stack.add(children[i]);
    }
    return true;
  }
}

/// Итератор для обхода графа в ширину
class BreadthFirstIterator extends BaseNodeIterator {
  final Queue<Node> _queue = Queue();

  BreadthFirstIterator(super.graph) {
    _queue.add(graph.root);
  }

  @override
  bool moveNext() {
    if (_queue.isEmpty) return false;
    final node = _queue.removeFirst();
    setCurrent(node);
    for (final child in graph.getNodeEdges(node)) {
      _queue.add(child);
    }
    return true;
  }
}

/// Итератор для обхода листьев графа
class LeavesIterator extends BaseNodeIterator {
  final List<Node> _stack = [];

  LeavesIterator(super.graph) {
    _stack.add(graph.root);
  }

  @override
  bool moveNext() {
    while (_stack.isNotEmpty) {
      final node = _stack.removeLast();
      final children = graph.getNodeEdges(node);

      if (children.isEmpty) {
        setCurrent(node);
        return true;
      }

      final list = children.toList();
      for (var i = list.length - 1; i >= 0; i--) {
        _stack.add(list[i]);
      }
    }
    return false;
  }
}

/// Итератор для обхода графа по уровням (lazy — обрабатывает один уровень за раз)
class LevelIterator extends BaseNodeCollectionIterator<Set<Node>> {
  final Queue<Node> _queue = Queue();

  LevelIterator(super.graph) {
    _queue.add(graph.root);
  }

  @override
  bool moveNext() {
    if (_queue.isEmpty) return false;

    final levelSize = _queue.length;
    final level = <Node>{};

    for (var i = 0; i < levelSize; i++) {
      final node = _queue.removeFirst();
      level.add(node);
      for (final child in graph.getNodeEdges(node)) {
        _queue.add(child);
      }
    }

    setCurrent(level);
    return true;
  }
}

/// Итератор для обхода с backtracking
class BacktrackIterator extends BaseNodeCollectionIterator<List<Node>> {
  final List<Node> _currentPath;
  final Set<Node> _inPath;
  bool _hasNext = true;

  BacktrackIterator(super.graph)
      : _currentPath = [graph.root],
        _inPath = {graph.root};

  @override
  bool moveNext() {
    if (!_hasNext) return false;

    setCurrent(List.from(_currentPath));

    final currentNode = _currentPath.last;
    final children = graph.getNodeEdges(currentNode);

    for (final child in children) {
      if (!_inPath.contains(child)) {
        _currentPath.add(child);
        _inPath.add(child);
        return true;
      }
    }

    // Backtrack
    while (_currentPath.isNotEmpty) {
      final node = _currentPath.removeLast();
      _inPath.remove(node);

      if (_currentPath.isEmpty) {
        _hasNext = false;
        return true;
      }

      final parent = _currentPath.last;
      final siblings = graph.getNodeEdges(parent).toList();
      final nodeIndex = siblings.indexOf(node);

      for (final sibling in siblings.skip(nodeIndex + 1)) {
        if (!_inPath.contains(sibling)) {
          _currentPath.add(sibling);
          _inPath.add(sibling);
          return true;
        }
      }
    }

    _hasNext = false;
    return true;
  }
}

/// Итератор для обхода поддерева (BFS, без visited — дерево гарантирует отсутствие циклов)
class SubtreeIterator extends BaseNodeIterator {
  final Node root;
  final Queue<Node> _queue;

  SubtreeIterator(super.graph, this.root) : _queue = Queue()..add(root);

  @override
  bool moveNext() {
    if (_queue.isEmpty) return false;

    final node = _queue.removeFirst();
    setCurrent(node);

    for (final child in graph.getNodeEdges(node)) {
      _queue.add(child);
    }

    return true;
  }
}
