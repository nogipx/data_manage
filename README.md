# 🚀 Data Manage

[![Pub Version](https://img.shields.io/pub/v/data_manage)](https://pub.dev/packages/data_manage)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/data_manage)](https://pub.dev/packages/data_manage)
[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

A powerful and flexible package for data management in Dart/Flutter applications. Built with pure Dart, zero external dependencies.

## 🎯 Key Features

### 🌟 Zero Dependencies
- Built entirely with standard Dart libraries
- No external dependencies to manage
- Smaller package size and faster builds
- Direct use of Dart's powerful built-in features

### 🔄 CircularList ([documentation](doc/circular_list/README.md))
- Fixed-size list with automatic oldest element removal
- O(1) operations with efficient memory usage
- Built-in numeric operations (average, min/max, moving average)
- Change tracking with callbacks
- Full List interface compliance

### 🌳 Graph and Trees ([documentation](doc/graph/README.md))
- Efficient directed tree implementation
- Single-parent hierarchy with strict validation
- Advanced traversal and path finding algorithms
- Smart node data caching
- Extensible architecture

### 📊 Data Collections ([documentation](doc/data_collection/README.md))
- Powerful filtering and sorting capabilities using pure Dart collections
- Efficient state management with immutable data structures
- Type-safe operations with built-in Dart features

### 🚀 Event Repository ([documentation](doc/event_repository/README.md))
- Type-safe event handling using Dart's strong type system
- Automatic resource cleanup and memory leak prevention
- Efficient event processing with Dart Streams

### 🔗 Chain ([documentation](doc/chain/README.md))
- Type-safe data processing pipeline with rich error handling
- Powerful mixin system for retry, metrics, and conditional execution
- Perfect for complex workflows like API integrations, data imports, and payment processing

## 🎯 Installation

```yaml
dependencies:
  data_manage: ^3.0.0
```

## 📚 Documentation

- [Graph Implementation](doc/graph/README.md) - Detailed guide on graph functionality
- [Advanced Graph Guide](doc/graph/ADVANCED.md) - Advanced usage and concepts
- [Data Collection](doc/data_collection/README.md) - Guide on collection management
- [Event Repository](doc/event_repository/README.md) - Guide on event management system
- [CircularList](doc/circular_list/README.md) - High-performance fixed-size list implementation
- [Chain Implementation](doc/chain/README.md) - Type-safe data processing pipeline guide
- [Advanced Chain Guide](doc/chain/ADVANCED.md) - Complex scenarios and performance optimization

## 📄 License

[BSD 3-Clause License](LICENSE) - A permissive license that allows you to:
- ✅ Use the code commercially
- ✅ Modify the code
- ✅ Distribute the code
- ✅ Use in private projects

Requirements:
1. Include the original copyright notice
2. Include the license text
3. Don't use the author's name for promotion

For more details, see [Understanding the BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause) 