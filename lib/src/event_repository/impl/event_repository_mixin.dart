import 'dart:async';

import '../interfaces/_index.dart';

mixin EventRepositoryMixin<E> implements IEventRepository<E> {
  /// Контроллер для управления потоками событий.
  final StreamController<E> _controller = StreamController.broadcast();

  @override
  Stream<E> get stream => _controller.stream;

  /// Поток событий.
  @override
  Stream<T> on<T extends E>() =>
      _controller.stream.where((event) => event is T).cast<T>();

  @override
  void addEvent({required E event}) {
    _controller.add(event);
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
