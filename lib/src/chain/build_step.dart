import 'dart:async';

abstract class ChainStep<T> {
  FutureOr<T> handle(T data);
}

mixin VerboseStep {
  String get description => '';
  String get initMessage => '⚙️ Running $stepName';
  String get completeMessage => '';

  String get stepName => runtimeType.toString();
}

enum StepStatus { inProgress, completed, error }

abstract class StepListener {
  void onStepChanged(ChainStep step, StepStatus status, [Object? error]);
}
