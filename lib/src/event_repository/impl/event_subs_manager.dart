import 'dart:async';

import '../interfaces/_index.dart';

/// Type for stream modification functions.
/// Allows transforming a stream before creating a subscription.
typedef StreamModifier<T> = Stream<T> Function(Stream<T> s)?;

/// {@template eventsSubscriptions}
/// Implementation of [IEventsSubscriptions] optimized for memory leak prevention.
///
/// Key features:
/// - Creates maximum one subscription per type [T]
/// - Supports global transformations for all streams
/// - Automatically cleans up unused subscriptions
/// - Type-safe event handling with compile-time checks
///
/// Example usage:
/// ```dart
/// final subscriptions = EventsSubscriptions(eventStream,
///   transformAll: StreamTransformer.fromHandlers(...),
///   modifyAll: (stream) => stream.distinct(),
/// );
///
/// // Subscribe to events
/// final sub = subscriptions.subscribe<UserEvent>(
///   (event) => print(event),
///   onError: (e) => log.error(e),
/// );
///
/// // Cancel subscription
/// subscriptions.cancel<UserEvent>();
/// ```
/// {@endtemplate}
class EventsSubscriptions<E> implements IEventsSubscriptions<E> {
  /// Base event stream from which typed subscriptions are created.
  final Stream<E> _eventStream;

  /// Global transformer applied to all created streams.
  final StreamTransformer<E, E>? transformAll;

  /// Global modifier applied to all created streams.
  final StreamModifier<E>? modifyAll;

  /// Storage for active subscriptions.
  ///
  /// Key is event [Type], value is active [StreamSubscription].
  /// Stores maximum one subscription per type to prevent memory leaks.
  final Map<Type, StreamSubscription<E>> _subscriptionsMap = {};

  /// Creates a new subscription manager.
  ///
  /// Parameters:
  /// - [_eventStream] - base event stream
  /// - [transformAll] - global transformer for all streams
  /// - [modifyAll] - global modifier for all streams
  EventsSubscriptions(
    this._eventStream, {
    this.transformAll,
    this.modifyAll,
  });

  /// Creates a typed stream for events of type [T].
  ///
  /// Applies the following transformations:
  /// 1. Type filtering using [where] and [cast]
  /// 2. Applies global modifier [modifyAll] if set
  /// 3. Applies global transformer [transformAll] if set
  Stream<T> _on<T extends E>() {
    var typedStream = _eventStream.where((e) => e is T).cast<T>();
    if (modifyAll != null) {
      typedStream = modifyAll!(typedStream.cast<E>()).cast<T>();
    }
    if (transformAll != null) {
      typedStream = typedStream.transform(transformAll!.cast());
    }
    return typedStream;
  }

  @override
  StreamSubscription<T> subscribe<T extends E>(
    void Function(T event) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    StreamModifier<T>? modify,
    StreamTransformer<T, T>? transform,
  }) {
    // Return existing subscription if available
    if (_subscriptionsMap.containsKey(T)) {
      return _subscriptionsMap[T]! as StreamSubscription<T>;
    }

    // Create new subscription
    var typedStream = _on<T>();
    if (modify != null) {
      typedStream = modify(typedStream);
    }
    if (transform != null) {
      typedStream = typedStream.transform(transform);
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

  /// Cancels subscription for events of type [T].
  /// If no subscription exists for type [T], does nothing.
  @override
  void cancel<T extends E>() {
    final sub = _subscriptionsMap.remove(T);
    sub?.cancel();
  }

  /// Disposes all active subscriptions and clears the subscription map.
  /// Should be called when the subscription manager is no longer needed.
  @override
  Future<void> dispose() async {
    for (final sub in _subscriptionsMap.values) {
      await sub.cancel();
    }
    _subscriptionsMap.clear();
  }
}
