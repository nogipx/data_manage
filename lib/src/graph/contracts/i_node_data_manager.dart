/// Базовый интерфейс для менеджера данных узлов
abstract interface class INodeDataManager<T> {
  /// Текущие данные (unmodifiable view)
  Map<String, T> get data;

  /// Получить данные узла
  T? get(String nodeKey);

  /// Установить данные узла
  void set(String nodeKey, T data);

  /// Удалить данные узла
  void remove(String nodeKey);

  /// Очистить все данные
  void clear();

  /// Получить метрики использования
  Map<String, dynamic> getMetrics();
}
