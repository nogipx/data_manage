/// Chain of Responsibility pattern implementation with type-safe data transformation.
///
/// Provides a flexible way to build data processing pipelines with:
/// - Type-safe data flow between steps
/// - Rich error handling and rollback capabilities
/// - Execution control and monitoring
/// - Extensible mixin system
///
/// For detailed documentation see:
/// - [Chain Implementation](doc/chain/README.md)
/// - [Advanced Chain Guide](doc/chain/ADVANCED.md)

library chain;

export 'impl/_index.dart';
export 'mixins/_index.dart';
