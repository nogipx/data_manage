import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Positive behavior',
    () async {
      AggregatedBatch? resultBatch;

      final sut = BatchThrottleAggregator<String>(
        durationIdleBeforeConfirm: const Duration(milliseconds: 15),
        onConfirmBatch: (batch) {
          resultBatch = batch;
          print(resultBatch?.data);
        },
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 15));
      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(3));

      sut.add('other');
      await Future.delayed(const Duration(milliseconds: 15));

      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(1));
    },
  );

  test(
    'Add new data while confirm in progress is illegal',
    () async {
      AggregatedBatch? resultBatch;

      final sut = BatchThrottleAggregator<String>(
        durationIdleBeforeConfirm: const Duration(milliseconds: 15),
        onConfirmBatch: (batch) async {
          resultBatch = batch;
          print(resultBatch?.data);
          await Future.delayed(const Duration(milliseconds: 20));
        },
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 15));
      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(3));

      expect(() => sut.add('other'), throwsException);
    },
  );

  test(
    'Positive behavior after waiting for confirming batch',
    () async {
      AggregatedBatch? resultBatch;

      final sut = BatchThrottleAggregator<String>(
        durationIdleBeforeConfirm: const Duration(milliseconds: 15),
        onConfirmBatch: (batch) async {
          resultBatch = batch;
          print(resultBatch?.data);
          await Future.delayed(const Duration(milliseconds: 20));
        },
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 10));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 15));
      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(3));

      await Future.delayed(const Duration(milliseconds: 20));
      sut.add('other');
      await Future.delayed(const Duration(milliseconds: 15));

      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(1));
    },
  );
}
