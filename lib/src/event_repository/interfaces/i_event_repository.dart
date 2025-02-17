import 'dart:async';

/// {@template iEventRepository}
/// Interface for managing application events.
///
/// Provides functionality for:
/// - Broadcasting events to multiple subscribers
/// - Type-safe event filtering
/// - Resource cleanup
///
/// Generic type [E] represents the base event type that repository can handle.
/// {@endtemplate}
abstract interface class IEventRepository<E> {
  /// Stream of all events passing through the repository.
  /// Events are broadcasted to all active subscribers.
  Stream<E> get stream;

  /// Returns a filtered stream of events of specific type [T].
  ///
  /// Example:
  /// ```dart
  /// repository.on<UserLoggedIn>().listen((event) {
  ///   print('User logged in: ${event.data}');
  /// });
  /// ```
  Stream<T> on<T extends E>();

  /// Subscribes to events of type [T] with a callback.
  ///
  /// The [onData] callback is called for each event of type [T].
  /// If [onError] is provided, it will be called when [onData] throws an error.
  ///
  /// Returns a [StreamSubscription] that can be used to cancel the subscription.
  ///
  /// Example:
  /// ```dart
  /// final subscription = repository.subscribe<UserLoggedIn>(
  ///   (event) => print('User logged in: ${event.data}'),
  ///   onError: (error) => print('Error: $error'),
  /// );
  /// ```
  StreamSubscription<T> subscribe<T extends E>(
    void Function(T event) onData, {
    Function? onError,
  });

  /// Adds a new event to the repository.
  ///
  /// All active subscribers will receive this event if they match
  /// the event type requirements.
  ///
  /// Throws [StateError] if repository is disposed.
  void addEvent({required E event});

  /// Releases all resources associated with this repository.
  ///
  /// After disposal:
  /// - No new events can be added
  /// - Existing subscriptions will be closed
  /// - Repository becomes unusable
  Future<void> dispose();
}
