import 'package:test/test.dart';

import 'batch_throttle_aggregator/_run.dart' as batch_throttle_aggregator;
import 'data_collection/_run.dart' as data_collection;
import 'tree/_run.dart' as tree;

void main() {
  group('batch_throttle_aggregator', batch_throttle_aggregator.main);
  group('data_collection', data_collection.main);
  group('tree', tree.main);
}
