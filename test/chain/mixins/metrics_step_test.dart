import 'dart:async';
import 'package:test/test.dart';
import 'package:data_manage/src/chain/_index.dart';

void main() {
  group('MetricsStep', () {
    late ProcessingStep step;
    late ChainContext context;

    setUp(() {
      context = ChainContext();
      step = ProcessingStep();
    });

    test('successful step execution with metrics collection', () async {
      // Arrange
      final input = TestData(value: 'test', shouldSucceed: true);

      // Act
      final result = await step.handle(input, context);

      // Assert
      expect(result.value, equals('test_processed'));

      final metrics = context.getMetadata<List<StepMetrics>>(ProcessingStep.kMetricsKey)!;
      expect(metrics, hasLength(1));
      expect(metrics.first.isSuccess, isTrue);
      expect(metrics.first.duration, greaterThan(Duration.zero));
      expect(metrics.first.error, isNull);
    });

    test('error information is captured in metrics', () async {
      // Arrange
      final input = TestData(value: 'test', shouldSucceed: false);

      // Act & Assert
      await expectLater(
        () => step.handle(input, context),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          equals('test error'),
        )),
      );

      final metrics = context.getMetadata<List<StepMetrics>>(ProcessingStep.kMetricsKey)!;
      expect(metrics, hasLength(1));
      expect(metrics.first.isSuccess, isFalse);
      expect(metrics.first.duration, greaterThan(Duration.zero));
      expect(metrics.first.error, isA<StateError>());
    });

    test('maintains execution history of multiple runs', () async {
      // Arrange
      final input1 = TestData(value: 'test1', shouldSucceed: true);
      final input2 = TestData(value: 'test2', shouldSucceed: true);

      // Act
      await step.handle(input1, context);
      await step.handle(input2, context);

      // Assert
      final metrics = context.getMetadata<List<StepMetrics>>(ProcessingStep.kMetricsKey)!;
      expect(metrics, hasLength(2));
      expect(metrics.every((m) => m.isSuccess), isTrue);
    });

    test('supports custom metrics keys', () async {
      // Arrange
      final customStep = CustomMetricsStep();
      final input = TestData(value: 'test', shouldSucceed: true);

      // Act
      await customStep.handle(input, context);

      // Assert
      final metrics = context.getMetadata<List<StepMetrics>>(CustomMetricsStep.kMetricsKey)!;
      expect(metrics, hasLength(1));
    });
  });
}

// Неизменяемые классы данных для тестов
class TestData {
  const TestData({
    required this.value,
    required this.shouldSucceed,
  });

  final String value;
  final bool shouldSucceed;
}

class ProcessedData {
  const ProcessedData({required this.value});
  final String value;
}

class ProcessingStep extends ChainStep<TestData, ProcessedData>
    with MetricsStep<TestData, ProcessedData> {
  static const String kMetricsKey = 'processing_step';

  @override
  String get metricsKey => kMetricsKey;

  @override
  FutureOr<ProcessedData> executeWithMetrics(TestData data, ChainContext context) {
    if (!data.shouldSucceed) {
      throw StateError('test error');
    }
    return ProcessedData(value: '${data.value}_processed');
  }
}

class CustomMetricsStep extends ChainStep<TestData, ProcessedData>
    with MetricsStep<TestData, ProcessedData> {
  static const String kMetricsKey = 'custom_step';

  @override
  String get metricsKey => kMetricsKey;

  @override
  FutureOr<ProcessedData> executeWithMetrics(TestData data, ChainContext context) {
    return ProcessedData(value: '${data.value}_processed');
  }
}
