import 'package:equatable/equatable.dart';

abstract base class IEventBase<T> with EquatableMixin {
  const IEventBase({required this.data});

  final T? data;

  @override
  List<Object?> get props => [data];
}
