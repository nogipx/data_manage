import 'package:test/test.dart';

import 'filter_usecase_test.dart' as filter;
import 'match_usecase_test.dart' as match;
import 'sort_usecase_test.dart' as sort;

void main() {
  group('Filtering usecase', filter.main);
  group('Matching usecase', match.main);
  group('Sorting usecase', sort.main);
}
