import 'package:test/test.dart';

import 'tree_readable_test.dart' as tree_readable_test;
import 'tree_editable_test.dart' as tree_editable_test;

void main() {
  group('Tree editable', tree_editable_test.main);
  group('Tree readable', tree_readable_test.main);
}
