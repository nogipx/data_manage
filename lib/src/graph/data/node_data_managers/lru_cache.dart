import 'dart:collection';

import 'package:data_manage/src/graph/_index.dart';

/// Менеджер данных с LRU кэшем
///
/// Пример использования:
/// ```dart
/// final manager = NodeDataManager<String>(maxSize: 1000);
/// manager.set("node1", "some data");
/// final data = manager.get("node1"); // "some data"
/// ```
class LRUNodeDataManager<T> implements INodeDataManager<T> {
  /// Максимальный размер кэша
  final int maxSize;

  /// Кэш для хранения данных узлов
  /// LinkedHashMap автоматически сохраняет порядок доступа к элементам
  // ignore: prefer_collection_literals
  final _cache = LinkedHashMap<String, T>();

  /// Текущие данные в кэше (unmodifiable view)
  @override
  Map<String, T> get data => Map.unmodifiable(_cache);

  /// Счетчик обращений к кэшу (для метрик)
  int _hits = 0;
  int _misses = 0;

  LRUNodeDataManager({
    required this.maxSize,
  });

  /// Получить данные узла
  @override
  T? get(String nodeKey) {
    final value = _cache[nodeKey];
    if (value != null) {
      _hits++;
      // Обновляем позицию в LRU
      _cache.remove(nodeKey);
      _cache[nodeKey] = value;
      return value;
    }
    _misses++;
    return null;
  }

  /// Установить данные узла
  @override
  void set(String nodeKey, T data) {
    if (_cache.length >= maxSize) {
      // Удаляем старый элемент
      _cache.remove(_cache.keys.first);
    }
    _cache[nodeKey] = data;
  }

  /// Удалить данные узла
  @override
  void remove(String nodeKey) {
    _cache.remove(nodeKey);
  }

  /// Очистить все данные
  @override
  void clear() {
    _cache.clear();
    _hits = 0;
    _misses = 0;
  }

  /// Получить метрики использования кэша
  @override
  Map<String, dynamic> getMetrics() {
    final total = _hits + _misses;
    final hitRate = total > 0 ? _hits / total : 0.0;

    return {
      'size': _cache.length,
      'maxSize': maxSize,
      'hits': _hits,
      'misses': _misses,
      'hitRate': hitRate,
      'utilizationRate': _cache.length / maxSize,
    };
  }

  /// Получить список наименее используемых ключей
  List<String> getLeastUsedKeys([int count = 10]) {
    return _cache.keys.take(count).toList();
  }

  /// Получить список последних использованных ключей
  List<String> getMostRecentlyUsedKeys([int count = 10]) {
    return _cache.keys.toList().reversed.take(count).toList();
  }
}
