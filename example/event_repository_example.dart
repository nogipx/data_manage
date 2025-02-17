import 'package:data_manage/src/event_repository/_index.dart';

/// Base event class for application events.
base class AppEvent<T> extends IEventBase<T> {
  const AppEvent({required super.data});
}

// Define custom event
base class UserLoggedIn extends AppEvent<String> {
  const UserLoggedIn({required String userId}) : super(data: userId);
}

/// Type alias for event subscriptions manager specialized for [AppEvent].
typedef IAppEventsSubscriptions<T> = IEventsSubscriptions<AppEvent<T>>;

/// Type alias for event repository specialized for [AppEvent].
typedef IAppEventRepository<T> = IEventRepository<AppEvent<T>>;

/// Default implementation of application event repository.
class AppEventRepository<T> with EventRepositoryMixin<AppEvent<T>> {}

/// Creates a new instance of event subscriptions manager for [AppEvent].
IAppEventsSubscriptions<T> createAppEventsSubscriptions<T>(
  IEventRepository<AppEvent<T>> repo,
) =>
    createRepositoryEventsSubscriptions(repo);

// Example usage
void main() async {
  // Create repository and subscriptions
  final repository = AppEventRepository<String>();
  final subscriptions = createAppEventsSubscriptions(repository);

  // Subscribe to events
  subscriptions.on<UserLoggedIn>((event) {
    print('User logged in: ${event.data}');
  });

  // Emit events
  repository.addEvent(event: UserLoggedIn(userId: 'user123'));

  // Clean up
  await subscriptions.dispose();
  await repository.dispose();
}
