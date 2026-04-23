// SPDX-FileCopyrightText: 2026 Karim "nogipx" Mamatkazin <nogipx@gmail.com>
//
// SPDX-License-Identifier: MIT

import '../_index.dart';

enum VisitResult {
  continueVisit,
  breakVisit,
}

typedef VisitCallback = VisitResult Function(Node node);
typedef BacktrackCallback = VisitResult Function(List<Node> path);
