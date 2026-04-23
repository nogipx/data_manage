# data_manage

[![Pub Version](https://img.shields.io/pub/v/data_manage)](https://pub.dev/packages/data_manage)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/data_manage)](https://pub.dev/packages/data_manage)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Data management utilities for Dart/Flutter. No external dependencies.

## Components

### Graph ([documentation](doc/graph/README.md))
Directed tree with single-parent hierarchy. Supports DFS, BFS, backtrack traversal, path finding, subtree views, and node data storage.

### CircularList ([documentation](doc/circular_list/README.md))
Fixed-size list with automatic oldest element removal. O(1) operations, numeric aggregations, change tracking.

### Data Collections ([documentation](doc/data_collection/README.md))
Filtering and sorting over Dart collections with composable matchers and type-safe operations.

### Event Repository ([documentation](doc/event_repository/README.md))
Type-safe event handling with automatic resource cleanup and Dart Streams integration.

### Chain ([documentation](doc/chain/README.md))
Data processing pipeline with error handling, retry, and conditional execution mixins.

## Installation

```yaml
dependencies:
  data_manage: ^3.1.0
```

## Documentation

- [Graph](doc/graph/README.md)
- [Advanced Graph](doc/graph/ADVANCED.md)
- [Data Collection](doc/data_collection/README.md)
- [Event Repository](doc/event_repository/README.md)
- [CircularList](doc/circular_list/README.md)
- [Chain](doc/chain/README.md)
- [Advanced Chain](doc/chain/ADVANCED.md)

## License

[MIT](LICENSE)
