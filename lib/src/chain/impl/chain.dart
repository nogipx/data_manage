import 'dart:async';

import 'context.dart';
import 'step.dart';

/// {@template chain}
/// A type-safe implementation of Chain of Responsibility pattern that transforms data
/// through a sequence of processing steps.
///
/// Key features:
/// * Type-safe data flow between steps
/// * Automatic rollback on failure
/// * Rich error handling and execution control
/// * Extensible through mixins
///
/// Example:
/// ```dart
/// final chain = Chain<RequestData, ResponseData>()
///   ..addStep(ValidationStep())
///   ..addStep(ProcessingStep());
///
/// final result = await chain.run(RequestData('test'));
/// ```
/// {@endtemplate}
class Chain<Initial, Final> {
  /// {@macro chain}
  Chain({
    Duration? timeout,
    Map<String, dynamic>? initialMetadata,
    this.shouldRollbackOnError = true,
  }) : context = ChainContext(
          timeout: timeout,
          initialMetadata: initialMetadata,
        );

  /// Whether to rollback completed steps on error
  final bool shouldRollbackOnError;

  /// Execution context shared between steps
  final ChainContext context;

  /// List of steps in the chain
  final List<ChainStep<dynamic, dynamic>> _steps = [];

  /// History of step executions
  final List<StepState<dynamic, dynamic>> _history = [];

  /// Unmodifiable view of step execution history
  List<StepState<dynamic, dynamic>> get history => List.unmodifiable(_history);

  /// Validates type compatibility between steps at runtime
  void _validateStepTypes<StepInput, StepOutput>(ChainStep<StepInput, StepOutput> step) {
    if (_steps.isEmpty) {
      if (step.inputType != Initial) {
        throw ArgumentError(
          'First step must accept Initial type ($Initial), but got ${step.inputType}',
        );
      }
      return;
    }

    final previousStep = _steps.last;
    if (step.inputType != previousStep.outputType) {
      throw ArgumentError(
        'Type mismatch: $previousStep outputs ${previousStep.outputType} but $step accepts ${step.inputType}',
      );
    }
  }

  /// Adds a step to the chain
  ///
  /// Validates type compatibility with previous step
  void addStep<StepInput, StepOutput>(ChainStep<StepInput, StepOutput> step) {
    _validateStepTypes(step);
    _steps.add(step);
  }

  /// Runs the chain with given initial data
  ///
  /// Returns the final transformed data
  /// Throws if any step fails and rollback is unsuccessful
  Future<Final> run(
    Initial initialData, {
    StepListener? listener,
  }) async {
    dynamic currentData = initialData;
    final completedSteps = <StepState<dynamic, dynamic>>[];

    try {
      for (final step in _steps) {
        if (context.shouldAbort) {
          await _rollback(completedSteps, listener);
          throw ChainAbortedException();
        }

        final state = StepState<dynamic, dynamic>(
          step: step,
          input: currentData,
          status: StepStatus.inProgress,
          startTime: DateTime.now(),
        );
        _history.add(state);
        listener?.onStepChanged(state);

        try {
          final output = await step.handle(currentData, context);
          final completedState = state.copyWith(
            output: output,
            status: StepStatus.completed,
            endTime: DateTime.now(),
          );
          _updateState(completedState);
          listener?.onStepChanged(completedState);
          completedSteps.add(completedState);
          currentData = output;
        } catch (error) {
          final errorState = state.copyWith(
            status: StepStatus.error,
            endTime: DateTime.now(),
            error: error,
          );
          _updateState(errorState);
          listener?.onStepChanged(errorState);
          rethrow;
        }
      }

      if (currentData is! Final) {
        throw StateError(
          'Chain output type mismatch: expected $Final but got ${currentData.runtimeType}',
        );
      }
      return currentData;
    } catch (e) {
      if (shouldRollbackOnError && e is! ChainAbortedException) {
        try {
          await _rollback(completedSteps, listener);
        } catch (rollbackError) {
          throw ChainRollbackException(e, rollbackError);
        }
      }
      rethrow;
    }
  }

  /// Rolls back completed steps in reverse order
  Future<void> _rollback(
    List<StepState<dynamic, dynamic>> completedSteps,
    StepListener? listener,
  ) async {
    for (final state in completedSteps.reversed) {
      try {
        await state.step.rollback(state.input, context);
        final rolledBackState = state.copyWith(
          status: StepStatus.rolledBack,
          endTime: DateTime.now(),
        );
        _updateState(rolledBackState);
        listener?.onStepChanged(rolledBackState);
      } catch (error) {
        final errorState = state.copyWith(
          status: StepStatus.error,
          endTime: DateTime.now(),
          error: error,
        );
        _updateState(errorState);
        listener?.onStepChanged(errorState);
        // Continue rolling back other steps
      }
    }
  }

  /// Updates state in history
  void _updateState(StepState<dynamic, dynamic> newState) {
    final index = _history.indexWhere((s) => s.step == newState.step);
    if (index != -1) {
      _history[index] = newState;
    }
  }

  /// Prints sequence of steps
  void printSequence() {
    final steps = _steps.map((step) {
      if (step is VerboseStep) {
        return (step).description;
      }
      return step.runtimeType.toString();
    });
    print(steps.join(' -> '));
  }
}

/// Thrown when chain execution is aborted
class ChainAbortedException implements Exception {
  @override
  String toString() => 'Chain execution was aborted';
}

/// Thrown when rollback fails
class ChainRollbackException implements Exception {
  ChainRollbackException(this.originalError, this.rollbackError);

  final Object originalError;
  final Object rollbackError;

  @override
  String toString() => 'Chain rollback failed.\n'
      'Original error: $originalError\n'
      'Rollback error: $rollbackError';
}
