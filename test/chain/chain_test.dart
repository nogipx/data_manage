import 'package:test/test.dart';
import 'package:data_manage/src/chain/_index.dart';

void main() {
  group('Chain', () {
    late TestData initialData;
    late Chain<TestData, ProcessedData> chain;
    late List<String> executionLog;

    setUp(() {
      initialData = TestData('test');
      executionLog = [];
      chain = Chain<TestData, ProcessedData>();
    });

    test('successful chain execution', () async {
      chain
        ..addStep(ValidateStep(executionLog))
        ..addStep(ProcessStep(executionLog));

      final result = await chain.run(initialData);

      expect(result.value, equals('test_processed'));
      expect(
          executionLog,
          equals([
            'validate: test',
            'process: test_validated',
          ]));
    });

    test('rollback on error', () async {
      chain
        ..addStep(ValidateStep(executionLog))
        ..addStep(FailingStep(executionLog))
        ..addStep(ProcessStep(executionLog));

      try {
        await chain.run(initialData);
        fail('Should throw');
      } catch (e) {
        expect(e, isA<TestException>());
        expect(
            executionLog,
            equals([
              'validate: test',
              'failing step',
              'rollback validate: test',
            ]));
      }
    });

    test('type validation between steps', () {
      chain.addStep(ValidateStep(executionLog));

      expect(
        () => chain.addStep(WrongInputStep()),
        throwsArgumentError,
      );
    });

    test('chain execution abort', () async {
      chain
        ..addStep(ValidateStep(executionLog))
        ..addStep(AbortingStep(executionLog))
        ..addStep(ProcessStep(executionLog));

      try {
        await chain.run(initialData);
        fail('Should throw ChainAbortedException');
      } catch (e) {
        expect(e, isA<ChainAbortedException>());
        expect(
            executionLog,
            equals([
              'validate: test',
              'aborting step',
              'rollback validate: test',
            ]));
      }
    });

    test('step state tracking', () async {
      final states = <StepState<dynamic, dynamic>>[];
      final listener = TestListener(states);

      chain
        ..addStep(ValidateStep(executionLog))
        ..addStep(ProcessStep(executionLog));

      await chain.run(initialData, listener: listener);

      expect(states.length, equals(4)); // 2 steps * 2 states
      expect(
          states.map((s) => s.status),
          equals([
            StepStatus.inProgress,
            StepStatus.completed,
            StepStatus.inProgress,
            StepStatus.completed,
          ]));
    });
  });
}

// Test data classes
class TestData {
  TestData(this.value);
  final String value;
}

class ValidatedData {
  ValidatedData(this.value);
  final String value;
}

class ProcessedData {
  ProcessedData(this.value);
  final String value;
}

class TestException implements Exception {
  @override
  String toString() => 'Test error';
}

// Test steps
class ValidateStep extends ChainStep<TestData, ValidatedData>
    with VerboseStep<TestData, ValidatedData> {
  ValidateStep(this.log);
  final List<String> log;

  @override
  String get description => 'Validates test data';

  @override
  ValidatedData handle(TestData data, ChainContext context) {
    log.add('validate: ${data.value}');
    return ValidatedData('${data.value}_validated');
  }

  @override
  Future<void> rollback(TestData data, ChainContext context) async {
    log.add('rollback validate: ${data.value}');
  }
}

class ProcessStep extends ChainStep<ValidatedData, ProcessedData>
    with VerboseStep<ValidatedData, ProcessedData> {
  ProcessStep(this.log);
  final List<String> log;

  @override
  String get description => 'Processes validated data';

  @override
  ProcessedData handle(ValidatedData data, ChainContext context) {
    log.add('process: ${data.value}');
    return ProcessedData('${data.value.replaceAll('_validated', '')}_processed');
  }
}

class FailingStep extends ChainStep<ValidatedData, ValidatedData>
    with VerboseStep<ValidatedData, ValidatedData> {
  FailingStep(this.log);
  final List<String> log;

  @override
  String get description => 'Always fails';

  @override
  ValidatedData handle(ValidatedData data, ChainContext context) {
    log.add('failing step');
    throw TestException();
  }
}

class AbortingStep extends ChainStep<ValidatedData, ValidatedData>
    with VerboseStep<ValidatedData, ValidatedData> {
  AbortingStep(this.log);
  final List<String> log;

  @override
  String get description => 'Aborts chain execution';

  @override
  ValidatedData handle(ValidatedData data, ChainContext context) {
    log.add('aborting step');
    context.shouldAbort = true;
    return data;
  }
}

class WrongInputStep extends ChainStep<String, ProcessedData>
    with VerboseStep<String, ProcessedData> {
  @override
  String get description => 'Step with wrong input type';

  @override
  ProcessedData handle(String data, ChainContext context) {
    return ProcessedData(data);
  }
}

class TestListener implements StepListener {
  TestListener(this.states);
  final List<StepState<dynamic, dynamic>> states;

  @override
  void onStepChanged(StepState<dynamic, dynamic> state) {
    states.add(state);
  }
}
