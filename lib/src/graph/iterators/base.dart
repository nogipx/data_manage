import '../_index.dart';

/// Базовый итератор для одиночных узлов
abstract class BaseNodeIterator implements Iterator<Node> {
  final IGraph<dynamic> graph;
  Node? _current;

  BaseNodeIterator(this.graph);

  @override
  Node get current {
    if (_current == null) {
      throw StateError('Iterator is not initialized or has no more elements');
    }
    return _current!;
  }

  @override
  bool moveNext();

  void setCurrent(Node value) => _current = value;
}

/// Базовый итератор для коллекций узлов
abstract class BaseNodeCollectionIterator<C extends Iterable<Node>> implements Iterator<C> {
  final IGraph<dynamic> graph;
  C? _current;

  BaseNodeCollectionIterator(this.graph);

  @override
  C get current {
    if (_current == null) {
      throw StateError('Iterator is not initialized or has no more elements');
    }
    return _current!;
  }

  @override
  bool moveNext();

  void setCurrent(C value) => _current = value;
}

/// Базовый класс для композитных итераторов
abstract class CompositeIterator<T> implements Iterator<T> {
  final Iterator<T> _source;
  T? _current;

  CompositeIterator(this._source);

  @override
  T get current {
    if (_current == null) {
      throw StateError('Iterator is not initialized or has no more elements');
    }
    return _current!;
  }

  @override
  bool moveNext();

  void setCurrent(T value) => _current = value;
}

/// Итератор с фильтрацией
class FilteredIterator<T> extends CompositeIterator<T> {
  final bool Function(T) predicate;

  FilteredIterator(super.source, this.predicate);

  @override
  bool moveNext() {
    while (_source.moveNext()) {
      if (predicate(_source.current)) {
        setCurrent(_source.current);
        return true;
      }
    }
    return false;
  }
}

/// Итератор с трансформацией
class MappedIterator<T, R> implements Iterator<R> {
  final Iterator<T> _source;
  final R Function(T) mapper;
  R? _current;

  MappedIterator(this._source, this.mapper);

  @override
  R get current {
    if (_current == null) {
      throw StateError('Iterator is not initialized or has no more elements');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    if (_source.moveNext()) {
      _current = mapper(_source.current);
      return true;
    }
    return false;
  }
}
