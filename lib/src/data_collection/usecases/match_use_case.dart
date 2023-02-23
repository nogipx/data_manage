import '../_index.dart';

class MatchUseCaseResult<T> {
  final Iterable<T> originalData;
  final Iterable<T> matchedData;
  final Iterable<MatchAction<T>> appliedMatchers;

  const MatchUseCaseResult({
    required this.originalData,
    required this.matchedData,
    required this.appliedMatchers,
  });
}

class MatchUseCase<T> implements UseCase<MatchUseCaseResult<T>> {
  final Iterable<T> data;
  final Iterable<MatchAction<T>> matchers;

  const MatchUseCase({
    this.data = const [],
    this.matchers = const [],
  });

  /// Применяет текущие матчеры.
  ///
  /// Проходится по данным и проверяет проходит ли объект матчеры.
  /// Ничего не делает, если список данных пустой.
  @override
  MatchUseCaseResult<T> run() {
    final enabledMatchers = matchers.where((e) => e.isEnabled);

    if (data.isNotEmpty && enabledMatchers.isNotEmpty) {
      final newFilteredData = <T>{};
      for (final item in data) {
        final isMatch = _isPassingMatchers(
          value: item,
          matchers: enabledMatchers,
        );
        if (isMatch) {
          newFilteredData.add(item);
        }
      }
      return MatchUseCaseResult(
        originalData: data,
        matchedData: newFilteredData,
        appliedMatchers: enabledMatchers,
      );
    }
    return MatchUseCaseResult(
      originalData: data,
      matchedData: data,
      appliedMatchers: matchers,
    );
  }

  /// Проверка на прохождение объектом матчеров.
  ///
  /// Если объект проходит хотя бы один матчер типа [MatchActionType.or],
  /// то считается прошедшим все матчеры.
  ///
  /// Далее объект проверяется на прохождение
  /// всех матчеров типа [MatchActionType.and].
  ///
  /// Объект считается прошедшим матчеры, если:
  /// - прошел хотя бы один матчер типа [MatchActionType.or]
  ///
  /// или
  /// - прошел все матчеры типа [MatchActionType.and]
  bool _isPassingMatchers({
    required T value,
    Iterable<MatchAction<T>> matchers = const [],
  }) {
    if (matchers.isEmpty) {
      return true;
    }

    final orMatchers =
        matchers.where((e) => e.type == MatchActionType.or).toList();

    final andMatchers =
        matchers.where((e) => e.type == MatchActionType.and).toList();

    final passOrList = orMatchers.map((e) => e.predicate(value));
    final passOr = passOrList.any((e) => e);

    if (passOr) {
      return true;
    }

    final matchAndList = andMatchers.map((e) => e.predicate(value));

    final matchesAnd =
        matchAndList.isNotEmpty ? matchAndList.every((e) => e) : false;

    if (matchesAnd) {
      return true;
    }

    return false;
  }

  /// Возвращает количество элементов, подходящих под матчеры.
  Future<int> countMatchedItems() async {
    final enabledMatchers = matchers.where((e) => e.isEnabled);

    int counter = 0;
    for (final item in data) {
      final isPassing = _isPassingMatchers(
        value: item,
        matchers: enabledMatchers,
      );
      if (isPassing) {
        counter++;
      }
    }
    return counter;
  }
}
