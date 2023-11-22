import 'dart:async';

import 'package:data_manage/data_manage.dart';

class TestAsyncDelegate implements IBatchThrottleDelegate<String> {
  AggregatedBatch? resultBatch;

  @override
  Duration get durationIdleBeforeConfirm => const Duration(milliseconds: 15);

  @override
  void onAddData(String data) {}

  @override
  FutureOr<void> onConfirmBatch(AggregatedBatch<String> batch) async {
    resultBatch = batch;
    print(resultBatch?.data);
    await Future.delayed(const Duration(milliseconds: 20));
  }

  @override
  void onError(Object? error, StackTrace trace) {}

  @override
  bool willConfirm() {
    return true;
  }
}

class TestSyncDelegate implements IBatchThrottleDelegate<String> {
  AggregatedBatch? resultBatch;

  @override
  Duration get durationIdleBeforeConfirm => const Duration(milliseconds: 15);

  @override
  void onAddData(String data) {}

  @override
  FutureOr<void> onConfirmBatch(AggregatedBatch<String> batch) async {
    resultBatch = batch;
    print(resultBatch?.data);
  }

  @override
  void onError(Object? error, StackTrace trace) {}

  @override
  bool willConfirm() {
    return true;
  }
}
