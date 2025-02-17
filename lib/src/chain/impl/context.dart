/// {@template chainContext}
/// Shared execution context for chain steps that provides metadata storage
/// and execution control capabilities.
///
/// Key features:
/// * Type-safe metadata storage
/// * Execution timeout control
/// * Chain abortion mechanism
/// * Cross-step communication
///
/// Example:
/// ```dart
/// final context = ChainContext(
///   timeout: Duration(seconds: 30),
///   initialMetadata: {'feature_enabled': true},
/// );
///
/// // Store and retrieve metadata
/// context.addMetadata('key', 'value');
/// final value = context.getMetadata<String>('key');
///
/// // Control execution
/// context.shouldAbort = true;
/// ```
/// {@endtemplate}
class ChainContext {
  /// {@macro chainContext}
  ChainContext({
    this.timeout,
    Map<String, dynamic>? initialMetadata,
  }) : _metadata = initialMetadata ?? {};

  /// Optional timeout for the entire chain execution
  final Duration? timeout;

  /// Whether the chain execution should be aborted
  bool shouldAbort = false;

  /// Start time of the chain execution
  final DateTime startTime = DateTime.now();

  /// Metadata storage for sharing data between steps
  final Map<String, dynamic> _metadata;

  /// Adds metadata that can be accessed by subsequent steps
  ///
  /// The [key] must be unique and [value] should be serializable
  void addMetadata(String key, dynamic value) => _metadata[key] = value;

  /// Retrieves metadata of specific type [T]
  ///
  /// Returns null if key doesn't exist or value is of wrong type
  /// Example:
  /// ```dart
  /// final value = context.getMetadata<int>('counter');
  /// final config = context.getMetadata<Map<String, dynamic>>('config');
  /// ```
  T? getMetadata<T>(String key) {
    final value = _metadata[key];
    if (value is T) return value;
    return null;
  }

  /// Removes metadata by key
  ///
  /// Returns true if metadata was removed, false if key didn't exist
  bool removeMetadata(String key) => _metadata.remove(key) != null;

  /// Clears all metadata
  void clearMetadata() => _metadata.clear();

  /// Returns all metadata keys
  Iterable<String> get keys => _metadata.keys;

  /// Returns true if context contains metadata with given key
  bool hasMetadata(String key) => _metadata.containsKey(key);
}
