# 🚀 Event Repository

A powerful and flexible event management system with type-safe subscriptions and memory leak prevention.

## 🌟 Key Features

### 📦 Event Management
- Type-safe event handling
- Broadcast event delivery
- Automatic resource cleanup
  > Repository automatically closes all streams and cancels subscriptions on `dispose()`. 
  > This prevents memory leaks and resource exhaustion in long-running applications.
- Memory leak prevention

### 🔄 Subscription Management
- Single subscription per event type
- Flexible stream transformations
- Global and local modifiers
- Automatic cleanup of unused subscriptions
  > The subscription manager maintains a strict "one subscription per type" policy:
  > ```dart
  > // First subscription
  > subscriptions.subscribe<UserEvent>((e) => print('Sub 1'));
  > 
  > // This replaces the first subscription, old one is automatically cancelled
  > subscriptions.subscribe<UserEvent>((e) => print('Sub 2'));
  > ```
  > When you create a new subscription for the same event type:
  > 1. Old subscription is automatically cancelled
  > 2. Resources are freed
  > 3. New subscription takes its place
  > This prevents subscription pileup and memory leaks.

### 🎨 Characteristics
- Type-safe at compile time
- Efficient memory usage
- Flexible configuration
- Clean architecture

## 📚 Usage

### Basic Example
```dart
// Create repository
final repository = EventRepository<BaseEvent>();

// Create subscription manager
final subscriptions = EventsSubscriptions(repository.stream);

// Subscribe to specific event type
final subscription = subscriptions.subscribe<UserEvent>(
  (event) => print('User event: ${event.data}'),
  onError: (e) => print('Error: $e'),
);

// Add event
repository.addEvent(event: UserEvent(data: 'user_data'));

// Cancel subscription when done
subscriptions.cancel<UserEvent>();
```

### Event Repository

The core component for event broadcasting:

```dart
class MyRepository with EventRepositoryMixin<BaseEvent> {
  void someAction() {
    addEvent(event: MyEvent(data: 'action_data'));
  }
}
```

### Subscription Management

Advanced subscription features:

```dart
final subscriptions = EventsSubscriptions(
  repository.stream,
  // Global transformations
  transformAll: StreamTransformer.fromHandlers(...),
  // Global modifiers
  modifyAll: (stream) => stream.distinct(),
);

// Local transformations
subscriptions.subscribe<UserEvent>(
  (event) => print(event),
  modify: (stream) => stream
    .where((e) => e.data != null)
    .distinct(),
  transform: StreamTransformer.fromHandlers(...),
);
```

## 🔧 Architecture

### Components
- `IEventRepository` - Base interface for event management
- `EventRepositoryMixin` - Default implementation with broadcast capabilities
- `IEventsSubscriptions` - Interface for subscription management
- `EventsSubscriptions` - Implementation with memory leak prevention

### Event Flow
1. Events are added to repository
2. Repository broadcasts events to all subscribers
3. Subscriptions filter events by type
4. Transformations are applied (if any)
5. Events are delivered to handlers

### Memory Management
- One subscription per event type
- Automatic cleanup on cancellation
- Resource disposal system
- Prevention of subscription leaks

## 🎯 Best Practices

1. **Type Safety**
   ```dart
   // Good
   repository.subscribe<UserEvent>((e) => ...);
   
   // Bad - no type checking
   repository.stream.listen((e) => ...);
   ```

2. **Resource Cleanup**
   ```dart
   // Always dispose when done
   @override
   void dispose() {
     subscriptions.dispose();
     super.dispose();
   }
   ```

3. **Event Handling**
   ```dart
   // Handle errors properly
   subscriptions.subscribe<UserEvent>(
     (event) => handleEvent(event),
     onError: (e) => handleError(e),
     cancelOnError: false,
   );
   ```

4. **Stream Transformations**
   ```dart
   // Use modifiers for complex logic
   subscriptions.subscribe<UserEvent>(
     (event) => print(event),
     modify: (stream) => stream
       .where((e) => e.isValid)
       .distinct()
       .timeout(Duration(seconds: 5)),
   );
   ```

## 🚀 Advanced Features

### Custom Event Types
```dart
abstract class BaseEvent {
  final dynamic data;
  const BaseEvent(this.data);
}

class UserEvent extends BaseEvent {
  final String userId;
  UserEvent({required this.userId}) : super({'id': userId});
}
```

### Error Handling
```dart
subscriptions.subscribe<UserEvent>(
  (event) => processEvent(event),
  onError: (error, stackTrace) {
    log.error('Failed to process event', error, stackTrace);
    analytics.trackError(error);
  },
  cancelOnError: false,
);
```

### Stream Transformation
```dart
// Debounce events
subscriptions.subscribe<UserEvent>(
  (event) => print(event),
  modify: (stream) => stream
    .debounceTime(Duration(milliseconds: 300))
    .distinct(),
);
```

### Memory Management Examples

```dart
// 1. Automatic Resource Cleanup
class UserRepository with EventRepositoryMixin<BaseEvent> {
  final subscriptions = EventsSubscriptions(...);
  
  @override
  Future<void> dispose() async {
    // This will:
    // 1. Close the event stream
    // 2. Cancel all active subscriptions
    // 3. Clear subscription map
    await super.dispose();
    await subscriptions.dispose();
  }
}

// 2. Subscription Replacement
void setupSubscriptions() {
  // First subscription
  subscriptions.subscribe<UserEvent>((e) => print('Handler 1'));
  
  // Later in code - old subscription is auto-cancelled
  subscriptions.subscribe<UserEvent>((e) => print('Handler 2'));
  
  // Manual cancellation - clears subscription for UserEvent
  subscriptions.cancel<UserEvent>();
}

// 3. Proper Cleanup in Widget
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final EventsSubscriptions<BaseEvent> subscriptions;
  
  @override
  void initState() {
    super.initState();
    subscriptions = EventsSubscriptions(repository.stream);
    
    // Setup subscriptions
    subscriptions.subscribe<UserEvent>((e) => handleUser(e));
    subscriptions.subscribe<SystemEvent>((e) => handleSystem(e));
  }
  
  @override
  void dispose() {
    // Automatically cancels all subscriptions
    subscriptions.dispose();
    super.dispose();
  }
} 