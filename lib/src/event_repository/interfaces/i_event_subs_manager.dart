import 'dart:async';

/// {@template iEventsSubscriptions}
/// Интерфейс класса управляющего подписками на конкретные события стрима.
/// {@endtemplate}
abstract interface class IEventsSubscriptions<E> {
  /// Подписаться на события типа [E]
  /// Пример:
  /// ```
  ///   eventsSubscriptions.on<UserLoggedIn>((event) {
  ///     print('Logged in: ${event.userId}');
  ///   });
  /// ```
  ///
  /// Возвращаем подписку, если вдруг понадобится отменить именно её вручную.
  StreamSubscription<T> on<T extends E>(
    void Function(T event) onData, {
    Stream<T> Function(Stream<T> stream)? modify,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    StreamTransformer<T, T>? transform,
  });

  /// Метод отмены конкретной подписки по типу
  void cancel<T extends E>();

  /// Метод групповой отмены подписок
  Future<void> dispose();
}
