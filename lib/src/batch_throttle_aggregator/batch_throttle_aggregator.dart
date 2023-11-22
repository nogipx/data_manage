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

  bool _isInProgress = false;
  bool get isConfirmInProgress => _isInProgress;

  @override
  void forceConfirm() {
    _onConfirm();
  }

  @override
  void add(T data) {
    if (_isInProgress) {
      throw Exception('Batch confirming in progress');
    }

    _data.add(data);

    if (_timer != null) {
      _resetTimer();
    }

    _timer = Timer(
      durationIdleBeforeConfirm,
      _onConfirm,
    );
  }

  void _onConfirm() async {
    final batch = AggregatedBatch(data: List.of(_data));
    _data.clear();

    _isInProgress = true;
    await onConfirmBatch(batch);
    _isInProgress = false;

    _resetTimer();
  }

  void _resetTimer() {
    _timer!.cancel();
    _timer = null;
  }
}
