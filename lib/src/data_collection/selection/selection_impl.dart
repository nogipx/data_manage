// ignore_for_file: prefer_collection_literals

import 'dart:collection';

import '../_index.dart';

class SelectionImpl<T> implements Selection<T> {
  final StateCallback<SelectionState<T>>? onStateChanged;

  @override
  final bool useStaging;

  @override
  final bool singleValue;

  @override
  SelectionState<T> get state => _state;
  SelectionState<T> _state;

  final LinkedHashSet<T> _selected;
  final LinkedHashSet<T> _staging;

  SelectionImpl({
    List<T> selected = const [],
    this.useStaging = false,
    this.singleValue = false,
    this.onStateChanged,
  })  : _selected = LinkedHashSet.from(selected),
        _staging = LinkedHashSet(),
        _state = SelectionState(
          selected: selected.toSet(),
          staging: {},
        );

  SelectionState<T> _update() {
    final newState = SelectionState(
      selected: useStaging ? {..._selected, ..._staging} : _selected,
      staging: _staging,
    );
    _state = newState;
    onStateChanged?.call(_state);
    return state;
  }

  void _select(T value) {
    if (useStaging) {
      if (singleValue) {
        _staging.clear();
      }
      _staging.add(value);
    } else {
      if (singleValue) {
        _selected.clear();
      }
      _selected.add(value);
    }
  }

  void _deselect(T value) {
    if (useStaging) {
      _staging.remove(value);
    }
    _selected.remove(value);
  }

  @override
  void toggle(T value) {
    if (singleValue) {
      deselectAll();
    }
    if (isSelected(value)) {
      deselect(value);
    } else {
      select(value);
    }
  }

  @override
  void select(T value) {
    _select(value);
    _update();
  }

  @override
  void deselect(T value) {
    _deselect(value);
    _update();
  }

  @override
  bool isSelected(T value) {
    if (useStaging) {
      return _staging.contains(value) || _selected.contains(value);
    } else {
      return _selected.contains(value);
    }
  }

  @override
  void selectAll(List<T> values) {
    for (final e in values) {
      _select(e);
    }
    _update();
  }

  @override
  void deselectAll() {
    if (useStaging) {
      _staging.clear();
    }
    _selected.clear();
    _update();
  }

  @override
  void applyStaging() {
    _selected.addAll(_staging);
    discardStaging();
  }

  @override
  void discardStaging() {
    _staging.clear();
    _update();
  }
}
