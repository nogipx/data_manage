import 'dart:collection';
import '../_index.dart';

/// Итератор для обхода графа в глубину
class DepthFirstIterator extends BaseNodeIterator {
  final Queue<Node> _queue = Queue();
  final Set<Node> _visited = {};

  DepthFirstIterator(super.graph) {
    _queue.add(graph.root);
  }

  @override
  bool moveNext() {
    while (_queue.isNotEmpty) {
      final node = _queue.removeLast();
      if (_visited.contains(node)) continue;

      _visited.add(node);
      setCurrent(node);

      final children = graph.getNodeEdges(node).toList();
      for (final child in children.reversed) {
        if (!_visited.contains(child)) {
          _queue.add(child);
        }
      }

      return true;
    }
    return false;
  }
}

/// Итератор для обхода графа в ширину
class BreadthFirstIterator extends BaseNodeIterator {
  final Queue<Node> _queue = Queue();
  final Set<Node> _visited = {};

  BreadthFirstIterator(super.graph) {
    _queue.add(graph.root);
  }

  @override
  bool moveNext() {
    while (_queue.isNotEmpty) {
      final node = _queue.removeFirst();
      if (_visited.contains(node)) continue;

      _visited.add(node);
      setCurrent(node);

      for (final child in graph.getNodeEdges(node)) {
        if (!_visited.contains(child)) {
          _queue.add(child);
        }
      }

      return true;
    }
    return false;
  }
}

/// Итератор для обхода листьев графа
class LeavesIterator extends BaseNodeIterator {
  final Queue<Node> _queue = Queue();
  final Set<Node> _visited = {};

  LeavesIterator(super.graph) {
    _queue.add(graph.root);
  }

  @override
  bool moveNext() {
    while (_queue.isNotEmpty) {
      final node = _queue.removeLast();
      if (_visited.contains(node)) continue;

      _visited.add(node);
      final children = graph.getNodeEdges(node);

      if (children.isEmpty) {
        setCurrent(node);
        return true;
      }

      for (final child in children.toList().reversed) {
        if (!_visited.contains(child)) {
          _queue.add(child);
        }
      }
    }
    return false;
  }
}

/// Итератор для обхода графа по уровням
class LevelIterator extends BaseNodeCollectionIterator<Set<Node>> {
  final Queue<_NodeWithLevel> _queue = Queue();
  final Set<Node> _visited = {};
  final Map<int, Set<Node>> _levels = {};
  int _currentLevel = 0;
  bool _isTraversalComplete = false;

  LevelIterator(super.graph) {
    _queue.add(_NodeWithLevel(graph.root, 0));
  }

  @override
  bool moveNext() {
    if (_isTraversalComplete && _currentLevel >= _levels.length) {
      return false;
    }

    if (!_isTraversalComplete) {
      while (_queue.isNotEmpty) {
        final currentNode = _queue.removeFirst();
        if (_visited.contains(currentNode.node)) continue;

        _visited.add(currentNode.node);
        _levels.putIfAbsent(currentNode.level, () => {}).add(currentNode.node);

        for (final child in graph.getNodeEdges(currentNode.node)) {
          if (!_visited.contains(child)) {
            _queue.add(_NodeWithLevel(child, currentNode.level + 1));
          }
        }
      }
      _isTraversalComplete = true;
    }

    if (_currentLevel < _levels.length) {
      setCurrent(_levels[_currentLevel]!);
      _currentLevel++;
      return true;
    }

    return false;
  }
}

/// Вспомогательный класс для обхода по уровням
class _NodeWithLevel {
  final Node node;
  final int level;
  _NodeWithLevel(this.node, this.level);
}
