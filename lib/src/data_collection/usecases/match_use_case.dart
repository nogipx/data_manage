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

class MatchUseCase<T> implements DataCollectionUseCase<MatchUseCaseResult<T>> {
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

    if (data.isEmpty) {
      return MatchUseCaseResult(
        originalData: data,
        matchedData: data,
        appliedMatchers: enabledMatchers,
      );
    }

    if (enabledMatchers.isEmpty) {
      return MatchUseCaseResult(
        originalData: data,
        matchedData: data,
        appliedMatchers: const [],
      );
    }

    final newFilteredData = <T>{};
    for (final item in data) {
      if (_isPassingMatchers(value: item, matchers: enabledMatchers)) {
        newFilteredData.add(item);
      }
    }

    return MatchUseCaseResult(
      originalData: data,
      matchedData: newFilteredData,
      appliedMatchers: enabledMatchers,
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
    if (matchers.isEmpty) return true;

    final orMatchers = matchers.where((e) => e.type == MatchActionType.or);
    final andMatchers = matchers.where((e) => e.type == MatchActionType.and);

    // Если есть OR матчеры, хотя бы один должен пройти
    if (orMatchers.isNotEmpty && !orMatchers.any((e) => e.predicate(value))) {
      return false;
    }

    // Если есть AND матчеры, все должны пройти
    if (andMatchers.isNotEmpty && !andMatchers.every((e) => e.predicate(value))) {
      return false;
    }

    return true;
  }

  /// Возвращает количество элементов, подходящих под матчеры.
  int countMatchedItems() {
    final enabledMatchers = matchers.where((e) => e.isEnabled);
    if (data.isEmpty) return 0;
    if (enabledMatchers.isEmpty) return data.length;

    int counter = 0;
    for (final item in data) {
      if (_isPassingMatchers(value: item, matchers: enabledMatchers)) {
        counter++;
      }
    }
    return counter;
  }
}
