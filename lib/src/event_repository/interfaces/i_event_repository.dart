/// {@template iEventRepository}
/// Интерфейс репозитория для управления событиями в приложении.
/// {@endtemplate}
abstract interface class IEventRepository<E> {
  /// Поток всех событий
  Stream<E> get stream;

  /// Поток конкретного события
  Stream<T> on<T extends E>();

  /// Метод для добавления события конкретного типа в общий поток событий.
  /// [event] - событие, добавляемое в поток.
  void addEvent({required E event});

  Future<void> dispose();
}
