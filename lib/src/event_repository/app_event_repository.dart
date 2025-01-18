import '_index.dart';

/// Базовое событие блоков/кубитов.
base class AppEvent<T> extends IEventBase<T> {
  const AppEvent({required super.data});
}

typedef IAppEventsSubscriptions = IEventsSubscriptions<AppEvent>;
typedef IAppEventRepository = IEventRepository<AppEvent>;

/// {@template appEventRepository}
/// Реализация репозитория для управления событиями в приложении.
/// {@endtemplate}
class AppEventRepository with EventRepositoryMixin<AppEvent> {}

IAppEventsSubscriptions createAppEventsSubscriptions(
  IEventRepository<AppEvent> repo,
) =>
    createRepositoryEventsSubscriptions(repo);
