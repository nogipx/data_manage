# 🎓 Possible Chain Usage (AI generated)

## 🔄 Complex Data Transformations

### Parallel Processing
```dart
class ParallelStep extends ChainStep<List<Data>, List<Result>> {
  @override
  Future<List<Result>> handle(List<Data> items, ChainContext context) async {
    final futures = items.map((item) => processItem(item, context));
    return Future.wait(futures);
  }
  
  Future<Result> processItem(Data item, ChainContext context) async {
    final innerChain = Chain<Data, Result>()
      ..addStep(TransformStep())
      ..addStep(ValidateStep());
      
    return innerChain.run(item);
  }
}
```

### Conditional Branching
```dart
class BranchingStep extends ChainStep<Input, Output> 
    with ConditionalStep<Input, Output> {
  
  final Chain<Input, Output> primaryChain;
  final Chain<Input, Output> fallbackChain;
  
  @override
  Future<Output> executeStep(Input data, ChainContext context) async {
    final condition = context.getMetadata<bool>('use_primary') ?? true;
    final chain = condition ? primaryChain : fallbackChain;
    return chain.run(data);
  }
}
```

## 🎯 Advanced Error Handling

### Error Recovery Strategy
```dart
mixin ErrorRecoveryStep<I, O> on ChainStep<I, O> {
  @override
  Future<O> handle(I data, ChainContext context) async {
    try {
      return await executeWithRecovery(data, context);
    } catch (e) {
      if (canRecover(e)) {
        context.addMetadata('recovered_from_error', e.toString());
        return await recoverFromError(data, context, e);
      }
      rethrow;
    }
  }
  
  Future<O> executeWithRecovery(I data, ChainContext context);
  bool canRecover(Object error) => false;
  Future<O> recoverFromError(I data, ChainContext context, Object error);
}
```

### Transaction-like Behavior
```dart
/// Metrics data for performance tracking
class PerformanceMetrics {
  final Duration duration;
  final int memoryUsage;
  final DateTime timestamp;

  const PerformanceMetrics({
    required this.duration,
    required this.memoryUsage,
    required this.timestamp,
  });
}

/// Span for distributed tracing
class Span {
  final String name;
  final Map<String, String> attributes = {};
  
  Span(this.name);
  
  Span child(String name) => Span('$this.$name');
  void addAttribute(String key, String value) => attributes[key] = value;
  Future<void> end() async => _endSpan();
  
  void setStatus(SpanStatus status, [String? message]) {
    attributes['status'] = status.name;
    if (message != null) attributes['error'] = message;
  }
}

enum SpanStatus {
  ok,
  error,
}

// Update TransactionalChain
abstract class TransactionalStep<I, O> extends ChainStep<I, O> {
  /// Commits the changes made by this step
  Future<void> commit() async {}
  
  /// Rolls back the changes made by this step
  @override
  Future<void> rollback(I data, ChainContext context) async {}
}

class TransactionalChain<I, O> extends Chain<I, O> {
  final List<TransactionalStep> _completedSteps = [];
  
  @override
  Future<O> run(I input, {StepListener? listener}) async {
    try {
      final result = await super.run(input, listener: listener);
      await _commit();
      return result;
    } catch (e) {
      await _rollback();
      rethrow;
    }
  }
  
  Future<void> _commit() async {
    for (final step in _completedSteps) {
      await step.commit();
    }
  }
  
  Future<void> _rollback() async {
    for (final step in _completedSteps.reversed) {
      await step.rollback(null, ChainContext());  // Pass appropriate data and context
    }
  }
}
```

## 📊 Advanced Metrics & Monitoring

### Performance Tracking
```dart
mixin PerformanceMetricsStep<I, O> on MetricsStep<I, O> {
  @override
  Future<O> executeWithMetrics(I data, ChainContext context) async {
    final stopwatch = Stopwatch()..start();
    final memoryBefore = ProcessInfo.currentRss;
    
    try {
      return await super.executeWithMetrics(data, context);
    } finally {
      final metrics = PerformanceMetrics(
        duration: stopwatch.elapsed,
        memoryUsage: ProcessInfo.currentRss - memoryBefore,
        timestamp: DateTime.now(),
      );
      context.addMetadata('${metricsKey}_performance', metrics);
    }
  }
}
```

### Distributed Tracing
```dart
mixin TracingStep<I, O> on ChainStep<I, O> {
  @override
  Future<O> handle(I data, ChainContext context) async {
    final span = context.getMetadata<Span>('parent_span')?.child(runtimeType.toString());
    
    span?.addAttribute('input_type', I.toString());
    span?.addAttribute('output_type', O.toString());
    
    try {
      final result = await super.handle(data, context);
      span?.setStatus(SpanStatus.ok);
      return result;
    } catch (error) {
      span?.setStatus(SpanStatus.error, error.toString());
      rethrow;
    } finally {
      await span?.end();
    }
  }
}
```

## 🔧 Advanced Configuration

### Dynamic Chain Building
```dart
class ChainBuilder<I, O> {
  final List<ChainStep> _steps = [];
  
  ChainBuilder<I, O> addIf(bool condition, ChainStep step) {
    if (condition) _steps.add(step);
    return this;
  }
  
  ChainBuilder<I, O> addUnless(bool condition, ChainStep step) {
    if (!condition) _steps.add(step);
    return this;
  }
  
  ChainBuilder<I, O> addAll(List<ChainStep> steps) {
    _steps.addAll(steps);
    return this;
  }
  
  Chain<I, O> build({
    Duration? timeout,
    bool shouldRollbackOnError = true,
  }) {
    final chain = Chain<I, O>(
      timeout: timeout,
      shouldRollbackOnError: shouldRollbackOnError,
    );
    
    for (final step in _steps) {
      chain.addStep(step);
    }
    
    return chain;
  }
}
```

### Configuration Management
```dart
class ChainConfig {
  final Duration timeout;
  final int maxRetries;
  final bool enableMetrics;
  final LogLevel logLevel;
  
  static ChainConfig fromJson(Map<String, dynamic> json) {
    return ChainConfig(
      timeout: Duration(milliseconds: json['timeout_ms']),
      maxRetries: json['max_retries'],
      enableMetrics: json['enable_metrics'],
      logLevel: LogLevel.values[json['log_level']],
    );
  }
}

class ConfigurableChain<I, O> extends Chain<I, O> {
  final ChainConfig config;
  
  @override
  Future<O> run(I input, {StepListener? listener}) {
    return super.run(
      input,
      listener: config.enableMetrics ? MetricsListener() : listener,
    ).timeout(config.timeout);
  }
}
```

## 🔍 Testing & Debugging

### Step Mocking
```dart
class MockStep<I, O> extends ChainStep<I, O> {
  final FutureOr<O> Function(I, ChainContext) mockHandler;
  final void Function(I, ChainContext)? onCalled;
  
  int callCount = 0;
  List<I> inputs = [];
  
  @override
  Future<O> handle(I data, ChainContext context) async {
    callCount++;
    inputs.add(data);
    onCalled?.call(data, context);
    return mockHandler(data, context);
  }
}
```

### Chain Testing
```dart
void main() {
  test('complex chain execution', () async {
    // Arrange
    final mockStep1 = MockStep<Input, Middle>((data, _) => Middle());
    final mockStep2 = MockStep<Middle, Output>((data, _) => Output());
    
    final chain = Chain<Input, Output>()
      ..addStep(mockStep1)
      ..addStep(mockStep2);
      
    // Act
    final result = await chain.run(Input());
    
    // Assert
    expect(mockStep1.callCount, equals(1));
    expect(mockStep2.callCount, equals(1));
    expect(result, isA<Output>());
  });
}
```

## 🚀 Performance Optimization

### Lazy Evaluation
```dart
class LazyChain<I, O> extends Chain<I, O> {
  final List<ChainStep Function()> _stepFactories;
  
  @override
  void addStep(ChainStep step) {
    _stepFactories.add(() => step);
  }
  
  @override
  Future<O> run(I input, {StepListener? listener}) {
    final chain = Chain<I, O>();
    for (final factory in _stepFactories) {
      chain.addStep(factory());
    }
    return chain.run(input, listener: listener);
  }
}
```

### Resource Management
```dart
mixin ResourceManagementStep<I, O> on ChainStep<I, O> {
  final _resources = <String, Resource>{};
  
  T getOrCreateResource<T extends Resource>(String key, T Function() factory) {
    return _resources.putIfAbsent(key, factory) as T;
  }
  
  @override
  Future<void> rollback(I data, ChainContext context) async {
    await super.rollback(data, context);
    await _disposeResources();
  }
  
  Future<void> _disposeResources() async {
    for (final resource in _resources.values) {
      await resource.dispose();
    }
    _resources.clear();
  }
}
```
