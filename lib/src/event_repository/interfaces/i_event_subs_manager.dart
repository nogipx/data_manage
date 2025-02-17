import 'dart:async';

/// {@template iEventsSubscriptions}
/// Interface for managing type-safe event subscriptions.
///
/// Provides functionality for:
/// - Type-safe event subscription management
/// - Individual and group subscription cancellation
/// - Stream transformation and error handling
///
/// Generic type [E] represents the base event type that can be subscribed to.
/// {@endtemplate}
abstract interface class IEventsSubscriptions<E> {
  /// Subscribes to events of specific type [T].
  ///
  /// Provides flexible stream configuration through optional parameters:
  /// - [modify] - custom stream transformation
  /// - [onError] - error handling
  /// - [onDone] - completion handling
  /// - [cancelOnError] - subscription behavior on error
  /// - [transform] - stream transformation using [StreamTransformer]
  ///
  /// Returns [StreamSubscription] that can be manually cancelled if needed.
  ///
  /// Example:
  /// ```dart
  /// final subscription = eventsSubscriptions.subscribe<UserLoggedIn>(
  ///   (event) => print('User logged in: ${event.data}'),
  ///   modify: (stream) => stream.distinct(),
  ///   onError: (e) => print('Error: $e'),
  /// );
  /// ```
  StreamSubscription<T> subscribe<T extends E>(
    void Function(T event) onData, {
    Stream<T> Function(Stream<T> stream)? modify,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    StreamTransformer<T, T>? transform,
  });

  /// Cancels all subscriptions for events of type [T].
  ///
  /// After cancellation, no events of type [T] will be received
  /// until new subscriptions are created.
  void cancel<T extends E>();

  /// Cancels all active subscriptions and releases resources.
  ///
  /// After disposal:
  /// - All subscriptions are cancelled
  /// - No new subscriptions can be created
  /// - Manager becomes unusable
  Future<void> dispose();
}
