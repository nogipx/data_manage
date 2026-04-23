class Node {
  final String key;

  const Node(this.key);

  @override
  bool operator ==(Object other) => other is Node && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'Node($key)';
}
