import 'dart:collection';
import '../_index.dart';

/// Итератор для обхода пути между двумя узлами
class PathIterator extends BaseNodeIterator {
  final Node start;
  final Node end;
  final List<Node> _path;
  int _currentIndex = 0;

  PathIterator(super.graph, this.start, this.end)
      : _path = graph.getVerticalPathBetweenNodes(start, end).toList();

  @override
  bool moveNext() {
    if (_currentIndex >= _path.length) return false;
    setCurrent(_path[_currentIndex++]);
    return true;
  }
}

/// Итератор для обхода с backtracking
class BacktrackIterator extends BaseNodeCollectionIterator<List<Node>> {
  final List<Node> _currentPath;
  bool _hasNext = true;

  BacktrackIterator(super.graph) : _currentPath = [graph.root];

  @override
  bool moveNext() {
    if (!_hasNext) return false;

    setCurrent(List.from(_currentPath));

    // Если текущий узел имеет непосещенных детей, идем к первому
    final currentNode = _currentPath.last;
    final children = graph.getNodeEdges(currentNode);

    for (final child in children) {
      if (!_currentPath.contains(child)) {
        _currentPath.add(child);
        return true;
      }
    }

    // Если нет непосещенных детей, возвращаемся назад
    while (_currentPath.isNotEmpty) {
      final node = _currentPath.removeLast();
      if (_currentPath.isEmpty) {
        _hasNext = false;
        return true;
      }

      final parent = _currentPath.last;
      final siblings = graph.getNodeEdges(parent);
      final nodeIndex = siblings.toList().indexOf(node);

      // Проверяем следующих сиблингов
      for (final sibling in siblings.skip(nodeIndex + 1)) {
        if (!_currentPath.contains(sibling)) {
          _currentPath.add(sibling);
          return true;
        }
      }
    }

    _hasNext = false;
    return true;
  }
}

/// Итератор для обхода поддерева
class SubtreeIterator extends BaseNodeIterator {
  final Node root;
  final Queue<Node> _queue;
  final Set<Node> _visited;

  SubtreeIterator(super.graph, this.root)
      : _queue = Queue()..add(root),
        _visited = {};

  @override
  bool moveNext() {
    if (_queue.isEmpty) return false;

    setCurrent(_queue.removeFirst());
    _visited.add(current);

    final children = graph.getNodeEdges(current);
    for (final child in children) {
      if (!_visited.contains(child)) {
        _queue.add(child);
      }
    }

    return true;
  }
}
