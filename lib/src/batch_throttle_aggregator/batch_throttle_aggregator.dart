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
    delegate.onAddDataToBatch(data);

    if (_timer != null) {
      _clearTimer();
    }

    _timer = Timer(
      delegate.durationIdleBeforeConfirm,
      _onConfirm,
    );
  }

  void _onConfirm() async {
    AggregatedBatch<T> batch = AggregatedBatch(data: []);

    try {
      if (!delegate.willConfirm()) {
        return;
      }
      _isInProgress = true;

      final dataToConfirm = List.of(_data);
      _data.clear();
      batch = AggregatedBatch(data: dataToConfirm);

      await delegate.confirmBatch(batch);
    } on Object catch (error, trace) {
      delegate.onConfirmingError(error, trace);
      rethrow;
    } finally {
      _isInProgress = false;
      _clearTimer();
    }
  }

  void _clearTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
