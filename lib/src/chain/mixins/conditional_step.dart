import 'dart:async';
import '../_index.dart';

/// {@template conditionalStep}
/// Adds conditional execution capability to a chain step.
///
/// Allows skipping step execution based on a condition.
/// The condition can be based on input data, context state, or any other logic.
///
/// Example:
/// ```dart
/// class ValidationStep extends ChainStep<Data, Data>
///     with ConditionalStep<Data, Data> {
///
///   @override
///   bool shouldExecute(Data data, ChainContext context) {
///     return data.needsValidation;
///   }
///
///   @override
///   FutureOr<Data> executeStep(Data data, ChainContext context) {
///     // Validation logic
///     return data.validate();
///   }
/// }
/// ```
/// {@endtemplate}
mixin ConditionalStep<Input, Output> on ChainStep<Input, Output> {
  /// Whether the step should be executed
  ///
  /// Override this to provide custom condition logic
  bool shouldExecute(Input data, ChainContext context) => true;

  /// Value to return when step is skipped
  ///
  /// By default, returns input data cast to Output type
  Output getSkipValue(Input data) => data as Output;

  /// Override this instead of [handle]
  FutureOr<Output> executeStep(Input data, ChainContext context);

  @override
  FutureOr<Output> handle(Input data, ChainContext context) async {
    if (!shouldExecute(data, context)) {
      context.addMetadata('step_skipped', runtimeType.toString());
      return getSkipValue(data);
    }

    return executeStep(data, context);
  }
}
