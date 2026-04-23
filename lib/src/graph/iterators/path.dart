import '../_index.dart';

/// Итератор для обхода пути между двумя узлами
class PathIterator extends BaseNodeIterator {
  final Node start;
  final Node end;
  final List<Node> _path;
  int _currentIndex = 0;

  PathIterator(super.graph, this.start, this.end)
      : _path = graph.getPathBetweenNodes(start, end);

  @override
  bool moveNext() {
    if (_currentIndex >= _path.length) return false;
    setCurrent(_path[_currentIndex++]);
    return true;
  }
}
