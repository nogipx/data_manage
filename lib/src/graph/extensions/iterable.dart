import '../_index.dart';

/// Extension для удобного использования итераторов в for-in циклах
extension GraphIterable<T> on IGraphIterable<T> {
  /// Итерация по узлам в порядке обхода в глубину
  Iterable<Node> get depthNodes => _IterableGraph(depthIterator);

  /// Итерация по узлам в порядке обхода в ширину
  Iterable<Node> get breadthNodes => _IterableGraph(breadthIterator);

  /// Итерация по листьям графа
  Iterable<Node> get leaves => _IterableGraph(leavesIterator);

  /// Итерация по уровням графа
  Iterable<Set<Node>> get levels => _IterableGraph(levelIterator);

  /// Итерация по всем путям в графе
  Iterable<List<Node>> get paths => _IterableGraph(backtrackIterator);

  /// Создает Iterable для пути между узлами
  Iterable<Node> pathBetween(Node start, Node end) => _IterableGraph(pathIterator(start, end));

  /// Создает Iterable для поддерева
  Iterable<Node> subtree(Node root) => _IterableGraph(subtreeIterator(root));
}

/// Вспомогательный класс для создания Iterable из Iterator
class _IterableGraph<T> extends Iterable<T> {
  final Iterator<T> _iterator;
  _IterableGraph(this._iterator);

  @override
  Iterator<T> get iterator => _iterator;
}
