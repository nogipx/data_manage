import '_index.dart';

enum VisitResult {
  continueVisit,
  breakVisit,
}

typedef VisitCallback<T> = VisitResult Function(Node node);
typedef BacktrackCallback<T> = VisitResult Function(List<Node> path);
