import '_index.dart';

/// Базовое событие блоков/кубитов.
base class AppEvent<T> extends IEventBase<T> {
  const AppEvent({required super.data});
}

typedef IAppEventsSubscriptions<T> = IEventsSubscriptions<AppEvent<T>>;
typedef IAppEventRepository<T> = IEventRepository<AppEvent<T>>;

/// {@template appEventRepository}
/// Реализация репозитория для управления событиями в приложении.
/// {@endtemplate}
class AppEventRepository<T> with EventRepositoryMixin<AppEvent<T>> {}

IAppEventsSubscriptions<T> createAppEventsSubscriptions<T>(
  IEventRepository<AppEvent<T>> repo,
) =>
    createRepositoryEventsSubscriptions(repo);
