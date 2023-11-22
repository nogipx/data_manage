import 'dart:async';

import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';

class BatchThrottleAggregator<T> implements IBatchThrottleAggregator<T> {
  BatchThrottleAggregator({
    required this.durationIdleBeforeConfirm,
    required this.onConfirmBatch,
  });

  @override
  final Duration durationIdleBeforeConfirm;

  @override
  final OnConfirmBatchThrottleAggregator<T> onConfirmBatch;

  Timer? _timer;
  final List<T> _data = [];

  @override
  void forceConfirm() {
    _onConfirm();
  }

  @override
  void add(T data) {
    _data.add(data);

    if (_timer != null) {
      _resetTimer();
    }

    _timer = Timer(
      durationIdleBeforeConfirm,
      _onConfirm,
    );
  }

  void _onConfirm() {
    final batch = AggregatedBatch(data: List.of(_data));
    _data.clear();
    onConfirmBatch(batch);

    _resetTimer();
  }

  void _resetTimer() {
    _timer!.cancel();
    _timer = null;
  }
}
