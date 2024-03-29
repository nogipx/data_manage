import 'dart:collection';

/// A [CircularBuffer] with a fixed capacity supporting all [List] operations
///
/// ```dart
/// final buffer = CircularBuffer<int>(3)..add(1)..add(2);
/// print(buffer.length); // 2
/// print(buffer.first); // 1
/// print(buffer.isFilled); // false
/// print(buffer.isUnfilled); // true
///
/// buffer.add(3);
/// print(buffer.length); // 3
/// print(buffer.isFilled); // true
/// print(buffer.isUnfilled); // false
///
/// buffer.add(4);
/// print(buffer.first); // 2
/// ```
class CircularBuffer<T> with ListMixin<T> {
  /// Creates a [CircularBuffer] with a `capacity`
  CircularBuffer({
    required this.capacity,
    this.changeListener,
  })  : assert(capacity > 1, 'CircularBuffer must have a positive capacity.'),
        _buf = [];

  final void Function(List<T> value)? changeListener;
  final List<T> _buf;

  /// Maximum number of elements of [CircularBuffer]
  final int capacity;

  int _start = 0;

  void _notifyListeners() {
    changeListener?.call(this);
  }

  /// Resets the [CircularBuffer].
  ///
  /// [capacity] is unaffected.
  void reset() {
    _start = 0;
    _buf.clear();
    _notifyListeners();
  }

  /// An alias to [reset].
  @override
  void clear() => reset();

  @override
  void add(T element) {
    if (isUnfilled) {
      // The internal buffer is not at its maximum size.  Grow it.
      assert(_start == 0, 'Internal buffer grown from a bad state');
      _buf.add(element);
      _notifyListeners();
      return;
    }

    // All space is used, so overwrite the start.
    _buf[_start] = element;
    _start++;
    if (_start == capacity) {
      _start = 0;
    }
    _notifyListeners();
  }

  @override
  T get last => this[_normalizeIndex(_buf.length - 1)];

  @override
  bool get isEmpty => _buf.isEmpty;

  @override
  bool get isNotEmpty => _buf.isNotEmpty;

  void replaceLast(T element) {
    if (isUnfilled) {
      assert(_start == 0, 'Internal buffer grown from a bad state');
    }

    this[_normalizeIndex(_buf.length - 1)] = element;
    _notifyListeners();
  }

  /// Number of used elements of [CircularBuffer]
  @override
  int get length => _buf.length;

  /// The [CircularBuffer] `isFilled` if the [length]
  /// is equal to the [capacity].
  bool get isFilled => _buf.length == capacity;

  /// The [CircularBuffer] `isUnfilled` if the [length] is
  /// less than the [capacity].
  bool get isUnfilled => _buf.length < capacity;

  int _normalizeIndex(int index) =>
      isFilled ? (_start + index) % _buf.length : index;

  @override
  T operator [](int index) {
    if (index >= 0 && index < _buf.length) {
      return _buf[_normalizeIndex(index)];
    }
    throw RangeError.index(index, this);
  }

  @override
  void operator []=(int index, T value) {
    if (index >= 0 && index < _buf.length) {
      _buf[_normalizeIndex(index)] = value;
      _notifyListeners();
    } else {
      throw RangeError.index(index, this);
    }
  }

  /// The `length` mutation is forbidden
  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot resize a CircularBuffer.');
  }
}
