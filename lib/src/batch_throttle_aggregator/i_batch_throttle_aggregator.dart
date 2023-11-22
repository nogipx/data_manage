import 'dart:async';

import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';

typedef OnConfirmBatchThrottleAggregator<T> = FutureOr<void> Function(
    AggregatedBatch<T> batch);

abstract class IBatchThrottleAggregator<T> {
  Duration get durationIdleBeforeConfirm;

  OnConfirmBatchThrottleAggregator<T> get onConfirmBatch;

  void add(T data);

  void forceConfirm();
}
