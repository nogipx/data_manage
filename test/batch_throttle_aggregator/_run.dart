import 'package:data_manage/src/batch_throttle_aggregator/_index.dart';
import 'package:data_manage/src/batch_throttle_aggregator/batch_throttle_agregator.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Positive behavior',
    () async {
      AggregatedBatch? resultBatch;

      final sut = BatchThrottleAggregator<String>(
        durationIdleBeforeConfirm: const Duration(milliseconds: 150),
        onConfirmBatch: (batch) {
          resultBatch = batch;
          print(resultBatch?.data);
        },
      );

      sut.add('1');
      await Future.delayed(const Duration(milliseconds: 100));
      sut.add('2');
      await Future.delayed(const Duration(milliseconds: 100));
      sut.add('3');

      await Future.delayed(const Duration(milliseconds: 150));
      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(3));

      sut.add('other');
      await Future.delayed(const Duration(milliseconds: 150));

      expect(resultBatch, isNotNull);
      expect(resultBatch?.data.length, equals(1));
    },
  );
}
