import '../_index.dart';

enum VisitResult {
  continueVisit,
  breakVisit,
}

typedef VisitCallback = VisitResult Function(Node node);
typedef BacktrackCallback = VisitResult Function(List<Node> path);
