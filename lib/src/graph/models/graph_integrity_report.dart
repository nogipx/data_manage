import 'node.dart';

/// Тип проблемы целостности графа.
enum GraphIntegrityIssueType {
  /// Родительская запись ссылается на дочерний узел, которого нет в графе.
  missingChild,

  /// Дочерний узел ссылается на родителя, которого нет в графе.
  missingParent,

  /// Родитель присутствует в `parents`, но отсутствует соответствующее ребро.
  inconsistentParentLink,

  /// В структуре ребер присутствует родительский узел, который отсутствует в графе.
  missingParentNode,
}

/// Описывает конкретную найденную проблему целостности графа.
class GraphIntegrityIssue {
  const GraphIntegrityIssue({
    required this.type,
    required this.node,
    this.related,
    required this.message,
  });

  /// Тип найденной проблемы.
  final GraphIntegrityIssueType type;

  /// Основной узел, к которому относится проблема.
  final Node node;

  /// Дополнительный узел, участвующий в проблеме (если есть).
  final Node? related;

  /// Человеко-читаемое описание.
  final String message;
}

/// Отчет о состоянии целостности графа.
class GraphIntegrityReport {
  const GraphIntegrityReport({
    this.issues = const [],
  });

  /// Список найденных проблем.
  final List<GraphIntegrityIssue> issues;

  /// Возвращает `true`, если структура графа целостна.
  bool get isClean => issues.isEmpty;

  /// Удобный хелпер для фильтрации проблем по типу.
  Iterable<GraphIntegrityIssue> issuesOf(GraphIntegrityIssueType type) =>
      issues.where((issue) => issue.type == type);
}
