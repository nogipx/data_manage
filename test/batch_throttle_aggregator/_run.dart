// ignore_for_file: inference_failure_on_instance_creation

import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';
import 'package:test/test.dart';

import 'data/delegates.dart';

TestAsyncDelegate _asyncDelegate() => TestAsyncDelegate();
TestSyncDelegate _syncDelegate() => TestSyncDelegate();

void main() {
  test(
    'Positive behavior',
    () async {
      final delegate = _syncDelegate();

      final sut = BatchThrottleAggregator<String>(
        delegate: delegate,
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 15));
      expect(delegate.resultBatch, isNotNull);
      expect(delegate.resultBatch?.data.length, equals(3));

      sut.add('other');
      await Future.delayed(const Duration(milliseconds: 15));

      expect(delegate.resultBatch, isNotNull);
      expect(delegate.resultBatch?.data.length, equals(1));
    },
  );

  test(
    'Add new data while confirm in progress is illegal',
    () async {
      final delegate = _asyncDelegate();

      final sut = BatchThrottleAggregator<String>(
        delegate: delegate,
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 15));
      expect(delegate.resultBatch, isNotNull);
      expect(delegate.resultBatch?.data.length, equals(3));

      expect(() => sut.add('other'), throwsException);
    },
  );

  test(
    'Positive behavior after waiting for confirming batch',
    () async {
      final delegate = _asyncDelegate();

      final sut = BatchThrottleAggregator<String>(
        delegate: delegate,
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 15));
      expect(delegate.resultBatch, isNotNull);
      expect(delegate.resultBatch?.data.length, equals(3));

      await Future.delayed(const Duration(milliseconds: 20));
      sut.add('other');
      await Future.delayed(const Duration(milliseconds: 15));

      expect(delegate.resultBatch, isNotNull);
      expect(delegate.resultBatch?.data.length, equals(1));
    },
  );
}
