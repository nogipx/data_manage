import '../_index.dart';

enum MatchActionType {
  /// Матчеры этого типа пропускают только те объекты,
  /// которые проходят все другие фильтры такого же типа.
  and,

  /// Матчеры этого типа пропускают объекты,
  /// которые проходят хотя бы один такой фильтр.
  or
}

class MatchAction<T> {
  final String key;
  final Predicate<T> predicate;
  final MatchActionType type;
  final bool isEnabled;

  const MatchAction({
    required this.key,
    required this.predicate,
    this.type = MatchActionType.and,
    this.isEnabled = true,
  });

  const MatchAction.or({
    required this.key,
    required this.predicate,
    this.isEnabled = true,
  }) : type = MatchActionType.or;

  const MatchAction.and({
    required this.key,
    required this.predicate,
    this.isEnabled = true,
  }) : type = MatchActionType.and;

  const MatchAction.disabled({
    required this.key,
    required this.predicate,
  })  : type = MatchActionType.and,
        isEnabled = false;

  @override
  bool operator ==(Object other) => other is MatchAction<T> && key == other.key;

  @override
  int get hashCode => Object.hashAll([key]);

  MatchAction<T>? copyWith({
    MatchActionType? type,
    bool? isEnabled,
  }) =>
      MatchAction<T>(
        key: key,
        predicate: predicate,
        type: type ?? this.type,
        isEnabled: isEnabled ?? this.isEnabled,
      );
}
