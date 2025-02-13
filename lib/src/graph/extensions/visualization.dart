import '../_index.dart';

/// Стиль визуализации графа
class GraphStyle {
  final String nodeShape;
  final String edgeStyle;
  final String graphDirection;
  final bool showNodeData;

  const GraphStyle({
    this.nodeShape = 'box',
    this.edgeStyle = '-->',
    this.graphDirection = 'TB',
    this.showNodeData = true,
  });

  static const GraphStyle defaultStyle = GraphStyle();
  static const GraphStyle roundedStyle = GraphStyle(nodeShape: 'rounded-box');
  static const GraphStyle circleStyle = GraphStyle(nodeShape: 'circle');
  static const GraphStyle leftToRight = GraphStyle(graphDirection: 'LR');
}

/// Расширение для добавления визуализации в граф
extension GraphVisualization<T> on IGraph<T> {
  /// Генерирует Mermaid-диаграмму для графа
  String toMermaid([GraphStyle style = GraphStyle.defaultStyle]) {
    final buffer = StringBuffer();
    buffer.writeln('graph ${style.graphDirection}');
    buffer.writeln('  %% Nodes');

    // Добавляем узлы
    for (final node in nodes.values) {
      final nodeData = style.showNodeData ? getNodeData(node.key)?.toString() : '';
      final label = nodeData?.isNotEmpty == true ? '${node.key}\\n$nodeData' : node.key;
      buffer.writeln('  ${node.key}[${_escapeMermaid(label)}]');
      buffer.writeln('  style ${node.key} ${style.nodeShape}');
    }

    buffer.writeln('  %% Edges');
    // Добавляем ребра
    for (final entry in edges.entries) {
      final from = entry.key;
      for (final to in entry.value) {
        buffer.writeln('  ${from.key} ${style.edgeStyle} ${to.key}');
      }
    }

    return buffer.toString();
  }

  /// Генерирует HTML с Mermaid-диаграммой
  String toMermaidHtml([GraphStyle style = GraphStyle.defaultStyle]) {
    final mermaid = toMermaid(style);
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Graph Visualization</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <script>
    mermaid.initialize({ startOnLoad: true });
  </script>
</head>
<body>
  <div class="mermaid">
$mermaid
  </div>
</body>
</html>
''';
  }

  /// Экранирует специальные символы Mermaid
  String _escapeMermaid(String text) {
    return text
        .replaceAll('"', '\\"')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]')
        .replaceAll('(', '\\(')
        .replaceAll(')', '\\)')
        .replaceAll('{', '\\{')
        .replaceAll('}', '\\}');
  }
}
