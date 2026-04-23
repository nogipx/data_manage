// SPDX-FileCopyrightText: 2026 Karim "nogipx" Mamatkazin <nogipx@gmail.com>
//
// SPDX-License-Identifier: MIT

/// Fixed-size list implementation with automatic oldest element removal.
///
/// Provides efficient memory usage and O(1) operations with features like:
/// - Automatic removal of oldest elements when capacity is reached
/// - Built-in numeric operations (average, min/max, moving average)
/// - Change tracking via callbacks
/// - Full List interface compliance
///
/// For detailed documentation see:
/// - [CircularList Documentation](doc/circular_list/README.md)

library;

export 'circular_list.dart';
