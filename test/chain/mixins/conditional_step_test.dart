import 'package:test/test.dart';
import 'package:data_manage/src/chain/_index.dart';

void main() {
  group('ConditionalStep', () {
    late ProcessingStep step;
    late ChainContext context;

    setUp(() {
      context = ChainContext();
      step = ProcessingStep();
    });

    test('processes data when condition is met', () async {
      // Arrange
      final input = TestData(value: 'test', shouldProcess: true);

      // Act
      final result = await step.handle(input, context);

      // Assert
      expect(result.value, equals('test_processed'));
    });

    test('skips processing when condition is not met', () async {
      // Arrange
      final input = TestData(value: 'test', shouldProcess: false);

      // Act
      final result = await step.handle(input, context);

      // Assert
      expect(result.value, equals('test'));
    });

    test('uses custom skip value when processing is skipped', () async {
      // Arrange
      final input = TestData(value: 'test', shouldProcess: false, skipValue: 'custom_skip');

      // Act
      final result = await step.handle(input, context);

      // Assert
      expect(result.value, equals('custom_skip'));
    });

    test('considers context state in decision making', () async {
      // Arrange
      context.addMetadata('feature_enabled', true);
      final input = TestData(value: 'test', shouldProcess: true, requiresFeature: true);

      // Act
      final result = await step.handle(input, context);

      // Assert
      expect(result.value, equals('test_processed'));
    });
  });
}

// Неизменяемые классы данных для тестов
class TestData {
  const TestData({
    required this.value,
    required this.shouldProcess,
    this.skipValue,
    this.requiresFeature = false,
  });

  final String value;
  final bool shouldProcess;
  final String? skipValue;
  final bool requiresFeature;
}

class ProcessedData {
  const ProcessedData({required this.value});
  final String value;
}

class ProcessingStep extends ChainStep<TestData, ProcessedData>
    with ConditionalStep<TestData, ProcessedData> {
  @override
  bool shouldExecute(TestData data, ChainContext context) {
    if (data.requiresFeature) {
      return data.shouldProcess && (context.getMetadata<bool>('feature_enabled') ?? false);
    }
    return data.shouldProcess;
  }

  @override
  ProcessedData getSkipValue(TestData data) {
    return ProcessedData(value: data.skipValue ?? data.value);
  }

  @override
  ProcessedData executeStep(TestData data, ChainContext context) {
    return ProcessedData(value: '${data.value}_processed');
  }
}
