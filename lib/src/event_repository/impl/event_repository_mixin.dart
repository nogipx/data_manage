import 'dart:async';

import '../interfaces/_index.dart';

/// {@template eventRepositoryMixin}
/// Default implementation of [IEventRepository] interface.
///
/// Uses [StreamController] in broadcast mode to manage event flow.
/// Provides type-safe event filtering and resource management.
///
/// {@macro eventRepositoryMixin}
///
/// Example:
/// ```dart
/// class MyRepository with EventRepositoryMixin<MyEvent> {}
/// ```
/// {@endtemplate}
mixin EventRepositoryMixin<E> implements IEventRepository<E> {
  /// Controller for managing event streams.
  /// Uses broadcast mode to support multiple subscribers.
  final StreamController<E> _controller = StreamController.broadcast();

  /// Returns a broadcast stream of all events.
  @override
  Stream<E> get stream => _controller.stream;

  /// Returns a filtered stream of events of specific type [T].
  /// Uses runtime type checking and casting for type safety.
  ///
  /// Errors in event handlers are caught and forwarded to the subscriber's
  /// error handler (if provided).
  @override
  Stream<T> on<T extends E>() => _controller.stream.where((event) => event is T).cast<T>();

  /// Adds a new event to the repository's stream.
  ///
  /// Throws [StateError] if repository is disposed.
  @override
  void addEvent({required E event}) {
    if (_controller.isClosed) {
      throw StateError('Cannot add events to a closed repository');
    }
    _controller.add(event);
  }

  /// Closes the stream controller and releases resources.
  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
