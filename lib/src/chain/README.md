# 🔗 Chain

A powerful and flexible implementation of the Chain of Responsibility pattern with type-safe data transformation, error handling, and execution control.

## ⚡️ Quick Start

```dart
// Define your data types
class RequestData {
  final String payload;
  RequestData(this.payload);
}

class ResponseData {
  final String result;
  ResponseData(this.result);
}

// Create processing steps
class ValidationStep extends ChainStep<RequestData, RequestData> {
  @override
  FutureOr<RequestData> handle(RequestData data, ChainContext context) {
    if (data.payload.isEmpty) throw ValidationError();
    return data;
  }
}

class ProcessingStep extends ChainStep<RequestData, ResponseData> {
  @override
  FutureOr<ResponseData> handle(RequestData data, ChainContext context) {
    return ResponseData('Processed: ${data.payload}');
  }
}

// Build and run the chain
final chain = Chain<RequestData, ResponseData>()
  ..addStep(ValidationStep())
  ..addStep(ProcessingStep());

final result = await chain.run(RequestData('test'));
```

## 🎯 Core Features

### Type-Safe Data Flow
- Compile-time type checking between steps
- Automatic type validation at runtime
- Clear data transformation path

### Rich Error Handling
- Automatic rollback on failure
- Detailed error context
- Custom error handling strategies

### Execution Control
- Step-by-step execution tracking
- Conditional processing
- Chain abortion mechanism
- Execution timeout support

### Extensibility
- Powerful mixin system
- Custom step implementations
- Flexible metadata storage

## 🧩 Built-in Mixins

### ⚡️ ConditionalStep
Adds conditional execution logic:
```dart
class ValidationStep extends ChainStep<Data, Data> 
    with ConditionalStep<Data, Data> {
  
  @override
  bool shouldExecute(Data data, ChainContext context) =>
    context.getMetadata<bool>('needsValidation') ?? true;
}
```

### 📊 MetricsStep
Collects execution metrics:
```dart
class ProcessingStep extends ChainStep<Input, Output> 
    with MetricsStep<Input, Output> {
  
  static const String kMetricsKey = 'processing_metrics';
  
  @override
  String get metricsKey => kMetricsKey;
}
```

## 🎨 Creating Custom Steps

1. Extend `ChainStep` with your types:
```dart
class MyStep extends ChainStep<InputType, OutputType> {
  @override
  FutureOr<OutputType> handle(InputType data, ChainContext context) {
    // Your transformation logic
  }
  
  @override
  Future<void> rollback(InputType data, ChainContext context) async {
    // Cleanup logic on failure
  }
}
```

2. Add mixins for extra features:
```dart
class MyStep extends ChainStep<Input, Output> 
    with ConditionalStep<Input, Output>,
         MetricsStep<Input, Output> {
  // Implementation
}
```

## 🚀 Best Practices

### Step Design
- Keep steps focused on single responsibility
- Use meaningful step and data type names
- Implement rollback for critical operations
- Document step behavior and requirements

### Chain Composition
- Order steps from general to specific
- Use type parameters to ensure data flow
- Add appropriate error handling
- Consider performance implications

### Context Usage
- Use context for cross-step communication
- Store only serializable metadata
- Clean up context after chain completion
- Document metadata keys and types

## 🎯 Real-World Examples

### API Request Processing
```dart
final apiChain = Chain<Request, Response>()
  ..addStep(ValidationStep())
  ..addStep(AuthenticationStep())
  ..addStep(RateLimitStep())
  ..addStep(ApiCallStep())
  ..addStep(ResponseMappingStep());
```

### Data Import Pipeline
```dart
final importChain = Chain<RawData, ProcessedData>()
  ..addStep(SchemaValidationStep())
  ..addStep(DataTransformationStep())
  ..addStep(DuplicateCheckStep())
  ..addStep(PersistenceStep());

// Run import with progress tracking
final listener = ImportProgressListener();
final result = await importChain.run(rawData, listener: listener);
```

### Payment Processing
```dart
final paymentChain = Chain<PaymentRequest, PaymentResult>()
  ..addStep(FraudDetectionStep())
  ..addStep(BalanceCheckStep())
  ..addStep(PaymentProcessingStep())
  ..addStep(NotificationStep());
```
