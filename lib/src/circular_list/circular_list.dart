import 'dart:collection';
import 'dart:math' as math;

/// {@template circularList}
/// A fixed-size list implementation that automatically removes oldest elements when capacity is reached.
///
/// Provides O(1) operations for most common tasks and efficient memory usage with fixed capacity.
/// Implements full [List] interface and adds specialized operations for numeric types.
///
/// Key features:
/// * Fixed memory footprint
/// * Automatic oldest element removal
/// * O(1) operations for add/remove/access
/// * Built-in numeric operations
/// * Change tracking via callbacks
///
/// Example:
/// ```dart
/// final list = CircularList<int>(3)
///   ..add(1)
///   ..add(2)
///   ..add(3);
/// print(list); // [1, 2, 3]
///
/// list.add(4);
/// print(list); // [2, 3, 4]
/// ```
///
/// For numeric types ([num], [int], [double]), additional operations are available:
/// ```dart
/// final prices = CircularList<double>(5)
///   ..addAll([10.5, 11.0, 9.8, 10.2, 10.8]);
///
/// print(prices.average); // 10.46
/// print(prices.movingAverage(3)); // last 3 values average
/// ```
///
/// Change tracking:
/// ```dart
/// final list = CircularList<int>(3,
///   onElementAdded: (e) => print('Added: $e'),
///   onElementRemoved: (e) => print('Removed: $e'),
/// );
/// ```
/// {@endtemplate}
class CircularList<T> with ListMixin<T> {
  /// {@macro circularList}
  CircularList(
    this.capacity, {
    this.onElementRemoved,
    this.onElementAdded,
  }) : assert(capacity > 1, 'Capacity must be greater than 1');

  /// Maximum number of elements that can be stored in the list.
  ///
  /// Once this limit is reached, adding new elements will remove the oldest ones.
  final int capacity;

  /// Called when an element is removed due to capacity overflow.
  ///
  /// This callback is triggered before the element is actually removed,
  /// allowing you to perform any necessary cleanup or logging.
  final void Function(T element)? onElementRemoved;

  /// Called when a new element is successfully added to the list.
  ///
  /// This callback is triggered after the element is added,
  /// allowing you to react to list changes.
  final void Function(T element)? onElementAdded;

  final List<T> _items = [];
  int _start = 0;

  /// Whether the list has reached its maximum capacity.
  ///
  /// When [isFull] is true, adding new elements will remove the oldest ones.
  bool get isFull => length == capacity;

  /// Whether the list can accept more elements without removing old ones.
  bool get hasSpace => length < capacity;

  /// Current number of elements in the list.
  @override
  int get length => _items.length;

  /// Calculates the average of all elements in the list.
  ///
  /// Only works with numeric types ([num], [int], [double]).
  /// Returns 0.0 for empty lists or non-numeric types.
  double get average {
    if (isEmpty) return 0.0;
    if (T == int || T == double || T == num) {
      final sum = fold<num>(0, (sum, item) => sum + (item as num));
      return sum / length;
    }
    return 0.0;
  }

  /// Calculates the sum of all elements in the list.
  ///
  /// Only works with numeric types ([num], [int], [double]).
  /// Returns 0 for empty lists or non-numeric types.
  num get sum {
    if (isEmpty) return 0;
    if (T == int || T == double || T == num) {
      return fold<num>(0, (sum, item) => sum + (item as num));
    }
    return 0;
  }

  /// Returns the maximum value in the list.
  ///
  /// Only works with numeric types ([num], [int], [double]).
  /// Throws [StateError] if the list is empty.
  /// Throws [UnsupportedError] for non-numeric types.
  T get max {
    if (isEmpty) {
      throw StateError('Cannot get max of empty list');
    }
    if (T == int || T == double || T == num) {
      return reduce((a, b) => (a as num) > (b as num) ? a : b);
    }
    throw UnsupportedError('Max is only supported for numeric types');
  }

  /// Returns the minimum value in the list.
  ///
  /// Only works with numeric types ([num], [int], [double]).
  /// Throws [StateError] if the list is empty.
  /// Throws [UnsupportedError] for non-numeric types.
  T get min {
    if (isEmpty) {
      throw StateError('Cannot get min of empty list');
    }
    if (T == int || T == double || T == num) {
      return reduce((a, b) => (a as num) < (b as num) ? a : b);
    }
    throw UnsupportedError('Min is only supported for numeric types');
  }

  /// Calculates the moving average over the specified window.
  ///
  /// Only works with numeric types ([num], [int], [double]).
  /// If [window] is null or larger than list length, uses all available elements.
  /// Returns 0.0 for empty lists or non-numeric types.
  ///
  /// Example:
  /// ```dart
  /// final prices = CircularList<double>(5)
  ///   ..addAll([10.0, 11.0, 12.0, 13.0, 14.0]);
  /// print(prices.movingAverage(3)); // average of last 3 prices
  /// ```
  double movingAverage([int? window]) {
    if (isEmpty) return 0.0;
    if (T == int || T == double || T == num) {
      final w = math.min(window ?? length, length);
      final start = math.max(0, length - w);
      var sum = 0.0;
      for (var i = start; i < length; i++) {
        sum += (this[i] as num);
      }
      return sum / w;
    }
    return 0.0;
  }

  /// Adds an element to the list.
  ///
  /// If the list is at capacity, removes the oldest element first.
  /// Triggers [onElementRemoved] if an element is removed.
  /// Triggers [onElementAdded] after the new element is added.
  @override
  void add(T element) {
    if (hasSpace) {
      _items.add(element);
      onElementAdded?.call(element);
      return;
    }

    final removed = this[0];
    onElementRemoved?.call(removed);

    _items[_start] = element;
    _start = (_start + 1) % capacity;
    onElementAdded?.call(element);
  }

  /// Adds all elements from an iterable to the list.
  ///
  /// Elements are added one by one, maintaining the circular behavior.
  /// Older elements are removed as needed to maintain capacity.
  @override
  void addAll(Iterable<T> elements) {
    for (final element in elements) {
      add(element);
    }
  }

  /// Returns the most recently added element.
  ///
  /// Equivalent to [last].
  T get latest => last;

  /// Returns the oldest element in the list.
  ///
  /// Equivalent to [first].
  T get oldest => first;

  /// Creates a regular [List] with elements in their current order.
  ///
  /// If [growable] is true, returns a growable list.
  @override
  List<T> toList({bool growable = true}) {
    if (isEmpty) return [];
    if (hasSpace) return List.from(_items, growable: growable);

    final result = List<T>.filled(length, _items.first, growable: growable);
    for (var i = 0; i < length; i++) {
      result[i] = this[i];
    }
    return result;
  }

  /// Creates a copy of this list with optionally modified parameters.
  ///
  /// The new list contains the same elements but can have different:
  /// * [capacity]
  /// * [onElementRemoved] callback
  /// * [onElementAdded] callback
  CircularList<T> copyWith({
    int? capacity,
    void Function(T)? onElementRemoved,
    void Function(T)? onElementAdded,
  }) {
    final copy = CircularList<T>(
      capacity ?? this.capacity,
      onElementRemoved: onElementRemoved ?? this.onElementRemoved,
      onElementAdded: onElementAdded ?? this.onElementAdded,
    );
    copy.addAll(toList());
    return copy;
  }

  int _normalizeIndex(int index) => isFull ? (_start + index) % length : index;

  /// Returns the element at the specified [index].
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  @override
  T operator [](int index) {
    if (index >= 0 && index < length) {
      return _items[_normalizeIndex(index)];
    }
    throw RangeError.index(index, this);
  }

  /// Sets the element at the specified [index].
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  @override
  void operator []=(int index, T value) {
    if (index >= 0 && index < length) {
      _items[_normalizeIndex(index)] = value;
    } else {
      throw RangeError.index(index, this);
    }
  }

  /// Setting length is not supported.
  ///
  /// Always throws [UnsupportedError].
  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot resize a CircularList');
  }

  /// Returns a string representation of the list.
  ///
  /// The format matches standard Dart list representation.
  @override
  String toString() => toList().toString();
}
