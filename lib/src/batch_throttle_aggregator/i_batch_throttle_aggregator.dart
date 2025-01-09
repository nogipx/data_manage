import 'dart:async';

import 'package:data_manage/data_manage.dart';
import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';

abstract class IBatchThrottleAggregator<T> {
  IBatchThrottleDelegate<T> get delegate;

  bool get isConfirmInProgress;

  void add(T data);

  void forceConfirm();
}

abstract class IBatchThrottleDelegate<T> {
  Duration get durationIdleBeforeConfirm;

  FutureOr<bool> willConfirm();

  FutureOr<void> confirmBatch(AggregatedBatch<T> batch);

  void onAddDataToBatch(T data);

  void onConfirmingError(Object? error, StackTrace trace);
}
