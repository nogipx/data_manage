import 'package:data_manage/src/graph/_index.dart';

/// Простой менеджер данных без ограничений
class SimpleNodeDataManager<T> implements INodeDataManager<T> {
  final _data = <String, T>{};
  int _hits = 0;
  int _misses = 0;

  @override
  Map<String, T> get data => Map.unmodifiable(_data);

  @override
  T? get(String nodeKey) {
    final value = _data[nodeKey];
    if (value != null) {
      _hits++;
      return value;
    }
    _misses++;
    return null;
  }

  @override
  void set(String nodeKey, T data) {
    _data[nodeKey] = data;
  }

  @override
  void remove(String nodeKey) {
    _data.remove(nodeKey);
  }

  @override
  void clear() {
    _data.clear();
    _hits = 0;
    _misses = 0;
  }

  @override
  Map<String, dynamic> getMetrics() {
    final total = _hits + _misses;
    final hitRate = total > 0 ? _hits / total : 0.0;

    return {
      'size': _data.length,
      'hits': _hits,
      'misses': _misses,
      'hitRate': hitRate,
    };
  }
}
