import 'dart:async';
import '../_index.dart';

/// {@template metricsStep}
/// Adds metrics collection capability to a chain step.
///
/// Collects execution metrics like duration, success rate, error count.
/// All metrics are stored in the chain context and can be accessed by key.
///
/// Example:
/// ```dart
/// class ApiStep extends ChainStep<Request, Response>
///     with MetricsStep<Request, Response> {
///
///   static const String _metricsKey = 'api_step';
///
///   @override
///   String get metricsKey => _metricsKey;
///
///   @override
///   FutureOr<Response> executeWithMetrics(Request data, ChainContext context) {
///     return apiClient.send(data);
///   }
/// }
/// ```
/// {@endtemplate}
mixin MetricsStep<Input, Output> on ChainStep<Input, Output> {
  /// Key for storing metrics in context
  ///
  /// Override this to provide custom metrics key.
  /// Best practice is to define a static const String in your step class:
  /// ```dart
  /// static const String _metricsKey = 'my_step';
  /// ```
  String get metricsKey;

  /// Override this instead of [handle]
  FutureOr<Output> executeWithMetrics(Input data, ChainContext context);

  @override
  FutureOr<Output> handle(Input data, ChainContext context) async {
    final metrics = StepMetrics();
    final startTime = DateTime.now();

    try {
      final result = await executeWithMetrics(data, context);

      metrics
        ..duration = DateTime.now().difference(startTime)
        ..isSuccess = true;

      return result;
    } catch (error) {
      metrics
        ..duration = DateTime.now().difference(startTime)
        ..isSuccess = false
        ..error = error;

      rethrow;
    } finally {
      final existingMetrics = context.getMetadata<List<StepMetrics>>(metricsKey) ?? [];
      context.addMetadata(metricsKey, [...existingMetrics, metrics]);
    }
  }
}

/// Immutable metrics data for a single step execution
class StepMetrics {
  /// When step execution started
  final DateTime startTime = DateTime.now();

  /// Duration of step execution
  Duration duration = Duration.zero;

  /// Whether step completed successfully
  bool isSuccess = false;

  /// Error that occurred during execution (if any)
  Object? error;

  /// Creates a copy of metrics with updated fields
  StepMetrics copyWith({
    Duration? duration,
    bool? isSuccess,
    Object? error,
  }) {
    return StepMetrics()
      ..duration = duration ?? this.duration
      ..isSuccess = isSuccess ?? this.isSuccess
      ..error = error ?? this.error;
  }

  @override
  String toString() {
    return 'StepMetrics('
        'duration: $duration, '
        'isSuccess: $isSuccess'
        '${error != null ? ', error: $error' : ''}'
        ')';
  }
}
