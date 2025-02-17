import 'package:equatable/equatable.dart';

/// {@template iEventBase}
/// Base interface for all application events.
/// Provides common functionality for event data handling and equality comparison.
///
/// Generic type [T] represents the type of data that event carries.
/// All events are equatable by their data.
///
/// {@macro iEventBase}
/// {@endtemplate}
abstract base class IEventBase<T> with EquatableMixin {
  /// {@macro iEventBase}
  const IEventBase({required this.data});

  /// The data associated with this event.
  /// Can be null if event doesn't carry any data.
  final T? data;

  /// Properties used for equality comparison.
  /// Events are considered equal if they have the same data.
  @override
  List<Object?> get props => [data];
}
