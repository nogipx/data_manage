// ignore_for_file: inference_failure_on_instance_creation

import 'dart:async';

import 'package:data_manage/data_manage.dart';

class TestAsyncDelegate implements IBatchThrottleDelegate<String> {
  AggregatedBatch<String>? resultBatch;

  @override
  Duration get durationIdleBeforeConfirm => const Duration(milliseconds: 15);

  @override
  void onAddDataToBatch(String data) {}

  @override
  FutureOr<void> confirmBatch(AggregatedBatch<String> batch) async {
    resultBatch = batch;
    print(resultBatch?.data);
    await Future.delayed(const Duration(milliseconds: 20));
  }

  @override
  bool willConfirm() {
    return true;
  }

  @override
  void onConfirmingError(Object? error, StackTrace trace) {}
}

class TestSyncDelegate implements IBatchThrottleDelegate<String> {
  AggregatedBatch<String>? resultBatch;

  @override
  Duration get durationIdleBeforeConfirm => const Duration(milliseconds: 15);

  @override
  void onAddDataToBatch(String data) {}

  @override
  FutureOr<void> confirmBatch(AggregatedBatch<String> batch) async {
    resultBatch = batch;
    print(resultBatch?.data);
  }

  @override
  bool willConfirm() {
    return true;
  }

  @override
  void onConfirmingError(Object? error, StackTrace trace) {}
}
