import 'dart:async';

import '../interfaces/_index.dart';

typedef StreamModifier<T> = Stream<T> Function(Stream<T> s)?;

/// Пример менеджера, в котором для каждого конкретного типа T
/// создаётся максимум одна подписка.
/// Повторный вызов `on<T>` вернёт ту же самую подписку,
/// чтобы не плодить лишних слушателей и избежать утечек.
class EventsSubscriptions<E> implements IEventsSubscriptions<E> {
  final Stream<E> _eventStream;
  final StreamTransformer<E, E>? transformAll;
  final StreamModifier<E>? modifyAll;

  /// Храним подписки в мапе: "тип события" -> "подписка"
  final Map<Type, StreamSubscription<E>> _subscriptionsMap = {};

  EventsSubscriptions(
    this._eventStream, {
    this.transformAll,
    this.modifyAll,
  });

  @override
  StreamSubscription<T> on<T extends E>(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    StreamModifier<T>? modify,
    StreamTransformer<T, T>? transform,
  }) {
    // Если уже есть подписка для T, возвращаем её
    if (_subscriptionsMap.containsKey(T)) {
      return _subscriptionsMap[T]! as StreamSubscription<T>;
    }

    // Иначе создаём новую подписку
    var typedStream = _eventStream.where((e) => e is T).cast<T>();
    if (modify != null) {
      typedStream = modify(typedStream);
    }

    if (transform != null) {
      typedStream = typedStream.transform(transform);
    } else if (transformAll != null) {
      typedStream = typedStream.transform(transformAll!.cast());
    }

    final subscription = typedStream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    _subscriptionsMap[T] = subscription as StreamSubscription<E>;

    return subscription;
  }

  @override
  void cancel<T extends E>() {
    final sub = _subscriptionsMap.remove(T);
    sub?.cancel();
  }

  @override
  Future<void> dispose() async {
    for (final sub in _subscriptionsMap.values) {
      await sub.cancel();
    }
    _subscriptionsMap.clear();
  }
}
