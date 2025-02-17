/// {@template iEventBase}
/// Base interface for all application events.
/// Provides common functionality for event data handling and equality comparison.
///
/// Generic type [T] represents the type of data that event carries.
/// All events are equatable by their data.
///
/// {@macro iEventBase}
/// {@endtemplate}
abstract base class IEventBase<T> {
  /// {@macro iEventBase}
  const IEventBase({required this.data});

  /// The data associated with this event.
  /// Can be null if event doesn't carry any data.
  final T? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IEventBase<T> && (data == other.data || (data == null && other.data == null));

  @override
  int get hashCode => data?.hashCode ?? 0;
}
