import 'package:test/test.dart';

import 'data_collection/_run.dart' as data_collection;
import 'tree/_run.dart' as tree;

void main() {
  group('data_collection', data_collection.main);
  group('tree', tree.main);
}
