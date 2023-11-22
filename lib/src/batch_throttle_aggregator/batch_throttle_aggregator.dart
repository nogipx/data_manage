import 'dart:async';

import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';

class BatchThrottleAggregator<T> implements IBatchThrottleAggregator<T> {
  BatchThrottleAggregator({
    required this.delegate,
  });

  @override
  final IBatchThrottleDelegate<T> delegate;

  @override
  bool get isConfirmInProgress => _isInProgress;
  bool _isInProgress = false;

  Timer? _timer;
  final List<T> _data = [];

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
    delegate.onAddData(data);

    if (_timer != null) {
      _resetTimer();
    }

    _timer = Timer(
      delegate.durationIdleBeforeConfirm,
      _onConfirm,
    );
  }

  void _onConfirm() async {
    final batch = AggregatedBatch(data: List.of(_data));

    try {
      if (!delegate.willConfirm()) {
        return;
      }

      _isInProgress = true;
      await delegate.onConfirmBatch(batch);

      _data.clear();
    } on Object catch (error, trace) {
      delegate.onError(error, trace);
      rethrow;
    } finally {
      _isInProgress = false;
      _resetTimer();
    }
  }

  void _resetTimer() {
    _timer!.cancel();
    _timer = null;
  }
}
