# 🔄 CircularList

A high-performance fixed-size list implementation that automatically removes oldest elements when capacity is reached.

## ⚡️ Quick Start

```dart
// Create a list with fixed capacity
final list = CircularList<int>(3);

// Add elements (automatically removes oldest when full)
list.addAll([1, 2, 3, 4]);
print(list); // [2, 3, 4]

// Track changes
final history = CircularList<String>(5,
  onElementAdded: (e) => print('Added: $e'),
  onElementRemoved: (e) => print('Removed: $e'),
);
```

## 🎯 Core Features

### Basic Operations
```dart
// Add elements
list.add(1);
list.addAll([2, 3, 4]);

// Access elements
print(list.latest); // most recent element
print(list.oldest); // oldest element
print(list[1]); // element at index

// Modify elements
list[1] = 10;
```

### Numeric Operations
Available for `int`, `double`, and `num` types:

```dart
final prices = CircularList<double>(5)
  ..addAll([10.5, 11.0, 9.8, 10.2, 10.8]);

// Statistical operations
print(prices.average); // 10.46
print(prices.min); // 9.8
print(prices.max); // 11.0
print(prices.sum); // 52.3

// Moving average with custom window
print(prices.movingAverage(3)); // last 3 values
```

### Change Tracking
```dart
final list = CircularList<int>(3,
  onElementAdded: (e) => print('Added: $e'),
  onElementRemoved: (e) => print('Removed: $e'),
);

list.addAll([1, 2, 3, 4]);
// Output:
// Added: 1, 2, 3
// Removed: 1
// Added: 4
```

### List Operations
```dart
// Create a copy with new capacity
final copy = list.copyWith(capacity: 5);

// Convert to regular List
final regular = list.toList();

// Standard List operations
list.isEmpty;
list.length;
list.first;
list.last;
```

## 🎨 Implementation Details

### Properties
- Fixed-size circular buffer implementation
- O(1) complexity for most operations
- Memory-efficient with no dynamic resizing
- Full `List` interface compliance
- Type-safe numeric operations

### Performance
- Element addition: O(1)
- Index access: O(1)
- Element removal: O(1)
- List conversion: O(n)

## 🚀 Real-World Applications

### Price History Tracking
```dart
final priceHistory = CircularList<double>(100);

void updatePrice(double price) {
  priceHistory.add(price);
  updateChart(priceHistory.movingAverage(20));
}
```

### Memory-Efficient Logging
```dart
final logBuffer = CircularList<LogEntry>(1000,
  onElementRemoved: writeToFile,
);

void log(LogEntry entry) => logBuffer.add(entry);
```

### Undo History
```dart
final history = CircularList<EditorState>(10);

void saveState(EditorState state) => history.add(state);
EditorState? undo() => history.isNotEmpty ? history.latest : null;
```

### Request Caching
```dart
final cache = CircularList<ApiRequest>(20);
void logRequest(ApiRequest req) => cache.add(req);
``` 