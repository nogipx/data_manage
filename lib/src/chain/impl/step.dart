import 'dart:async';

import 'context.dart';

/// {@template chainStep}
/// Base class for all chain processing steps that defines type-safe data transformation
/// and error handling behavior.
///
/// Key features:
/// * Type-safe input/output handling
/// * Asynchronous processing support
/// * Error handling with rollback
/// * Extensible through mixins
///
/// Example:
/// ```dart
/// class ValidationStep extends ChainStep<RequestData, RequestData> {
///   @override
///   Future<RequestData> handle(RequestData data, ChainContext context) async {
///     if (!isValid(data)) throw ValidationError();
///     return data;
///   }
///
///   @override
///   Future<void> rollback(RequestData data, ChainContext context) async {
///     // Cleanup logic
///   }
/// }
/// ```
/// {@endtemplate}
abstract class ChainStep<Input, Output> {
  /// {@macro chainStep}
  const ChainStep();

  /// Type of input data this step accepts
  Type get inputType => Input;

  /// Type of output data this step produces
  Type get outputType => Output;

  /// Handles the input data and produces output
  ///
  /// Override this to provide custom step logic.
  /// The [context] can be used to share data between steps.
  /// Throws if processing fails.
  FutureOr<Output> handle(Input data, ChainContext context);

  /// Optional rollback logic for the step
  ///
  /// Called when chain execution fails and rollback is requested.
  /// Use this to cleanup resources or revert changes.
  /// Default implementation does nothing.
  FutureOr<void> rollback(Input data, ChainContext context) async {}
}

/// {@template stepStatus}
/// Status of step execution that represents current state of processing.
///
/// Used for tracking step progress and handling errors.
/// {@endtemplate}
enum StepStatus {
  /// Step is currently executing
  inProgress,

  /// Step completed successfully
  completed,

  /// Step failed with error
  error,

  /// Step was rolled back
  rolledBack,

  /// Step was skipped
  skipped,
}

/// {@template stepState}
/// Immutable state of a single step execution that holds all execution details.
///
/// Key features:
/// * Input/output data tracking
/// * Execution timing
/// * Error information
/// * Status tracking
///
/// Example:
/// ```dart
/// final state = StepState(
///   step: ValidationStep(),
///   input: requestData,
///   status: StepStatus.completed,
///   startTime: DateTime.now(),
/// );
///
/// if (state.isSuccess) {
///   print('Duration: ${state.duration}');
/// }
/// ```
/// {@endtemplate}
class StepState<Input, Output> {
  /// {@macro stepState}
  StepState({
    required this.step,
    required this.input,
    this.output,
    required this.status,
    required this.startTime,
    this.endTime,
    this.error,
  });

  /// The step that was executed
  final ChainStep<Input, Output> step;

  /// Input data that was passed to the step
  final Input input;

  /// Output data produced by the step (if successful)
  final Output? output;

  /// Current status of the step
  final StepStatus status;

  /// When step execution started
  final DateTime startTime;

  /// When step execution ended (if completed)
  final DateTime? endTime;

  /// Error that occurred during execution (if any)
  final Object? error;

  /// Duration of step execution
  Duration? get duration => endTime?.difference(startTime);

  /// Whether step completed successfully
  bool get isSuccess => status == StepStatus.completed;

  /// Whether step failed with error
  bool get isError => status == StepStatus.error;

  /// Whether step was rolled back
  bool get isRolledBack => status == StepStatus.rolledBack;

  /// Whether step execution is finished
  bool get isFinished => status != StepStatus.inProgress;

  /// Creates a copy of this state with updated fields
  StepState<Input, Output> copyWith({
    Output? output,
    StepStatus? status,
    DateTime? endTime,
    Object? error,
  }) {
    return StepState(
      step: step,
      input: input,
      output: output ?? this.output,
      status: status ?? this.status,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      error: error ?? this.error,
    );
  }
}

/// {@template stepListener}
/// Listener for step execution events that allows tracking chain progress.
///
/// Used for monitoring, logging, and debugging chain execution.
/// {@endtemplate}
abstract class StepListener {
  /// Called when step status changes
  ///
  /// Use this to track step progress and handle state transitions
  void onStepChanged(StepState<dynamic, dynamic> stepState);
}

/// {@template verboseStep}
/// Mixin that adds logging and execution control capabilities to steps.
///
/// Key features:
/// * Custom step descriptions
/// * Progress messages
/// * Retry configuration
/// * Timeout control
///
/// Example:
/// ```dart
/// class ApiStep extends ChainStep<Request, Response>
///     with VerboseStep<Request, Response> {
///
///   @override
///   String get description => 'Calls external API';
///
///   @override
///   bool get shouldRetry => true;
///
///   @override
///   int get maxRetries => 3;
/// }
/// ```
/// {@endtemplate}
mixin VerboseStep<Input, Output> on ChainStep<Input, Output> {
  /// Description of what this step does
  String get description => '';

  /// Message to show when step starts
  String get initMessage => '⚙️ Running $stepName';

  /// Message to show when step completes
  String get completeMessage => '✅ Completed $stepName';

  /// Message to show when step fails
  String get errorMessage => '❌ Failed $stepName';

  /// Name of the step (defaults to class name)
  String get stepName => runtimeType.toString();

  /// Optional timeout for this specific step
  Duration? get timeout => null;

  /// Whether to retry on failure
  bool get shouldRetry => false;

  /// Maximum number of retries
  int get maxRetries => 1;

  /// Delay between retries
  Duration get retryDelay => const Duration(milliseconds: 100);
}
