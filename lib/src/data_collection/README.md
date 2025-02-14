# 🎯 Data Collection

A powerful and flexible tool for managing data collections with support for filtering, matching, and sorting.

## 🌟 Key Features

### 📊 Data Management
- Data filtering using predicates
- Matching with AND/OR conditions
- Flexible sorting
- Collection state preservation
- Automatic updates on changes

### 🔄 Operations
- **Filters**: Sequential application of multiple filters
- **Matchers**: Combining conditions through AND/OR
- **Sorting**: Custom comparators and directions
- **State**: Tracking of applied operations

### 🎨 Characteristics
- Immutable state
- Lazy evaluation
- Generic type support
- Optimized performance

## 📚 Usage

### Basic Example
```dart
final collection = DataCollection<String>(
  data: ['a', 'b', 'c', 'ab', 'bc'],
  defaultSort: SortAction(
    (a, b) => a.compareTo(b),
    direction: SortDirection.asc,
  ),
);

// Add a filter
collection.addFilter(FilterAction(
  key: 'contains_a',
  predicate: (e) => e.contains('a'),
));

// Add a matcher
collection.addMatcher(MatchAction(
  key: 'length_2',
  type: MatchActionType.and,
  predicate: (e) => e.length == 2,
));

// Apply changes
collection.actualize();

// Get result: ['ab']
print(collection.state.data);
```

### Filtering

Filters are applied sequentially and all conditions must be met:

```dart
collection
  ..addFilter(FilterAction(
    key: 'contains_b',
    predicate: (e) => e.contains('b'),
  ))
  ..addFilter(FilterAction(
    key: 'length_2',
    predicate: (e) => e.length == 2,
  ))
  ..actualize();
```

### Matching

Matchers support two types of conditions:
- `MatchActionType.and`: All conditions must be met
- `MatchActionType.or`: At least one condition must be met

```dart
collection
  ..addMatcher(MatchAction(
    key: 'contains_a',
    type: MatchActionType.or,
    predicate: (e) => e.contains('a'),
  ))
  ..addMatcher(MatchAction(
    key: 'contains_b',
    type: MatchActionType.or,
    predicate: (e) => e.contains('b'),
  ))
  ..actualize();
```

### Sorting

```dart
collection.applySort(SortAction(
  (a, b) => a.compareTo(b),
  direction: SortDirection.desc,
));
```

### Change Tracking

```dart
collection.listener = SimpleCollectionListener(
  actualizeListener: (state) {
    print('Collection updated: ${state.data}');
  },
  stateListener: (state) {
    print('State changed');
  },
);
```

## 🔧 Architecture

### Use Cases
- `FilterUseCase`: Filter application
- `MatchUseCase`: Matcher application
- `SortUseCase`: Sort application

### State
Collection state is stored in `DataCollectionState` and includes:
- Original data
- Current data
- Applied filters
- Applied matchers
- Current sorting

### Performance
- Lazy evaluation: operations are applied only on `actualize()`
- Efficient filtering: using Sets for uniqueness
- Optimized predicates: minimum data passes

## 🎯 Best Practices

1. **Unique Keys**
   ```dart
   // Good
   FilterAction(key: 'unique_filter_key', ...)
   
   // Bad
   FilterAction(key: 'filter', ...)
   ```

2. **Operation Order**
   ```dart
   // Recommended
   collection
     ..addFilter(...)    // Filters first
     ..addMatcher(...)   // Then matchers
     ..applySort(...)    // Sort last
     ..actualize();
   ```

3. **Disabling Operations**
   ```dart
   FilterAction(
     key: 'temp_filter',
     predicate: (e) => e.contains('a'),
     isEnabled: false,  // Temporarily disabled
   )
   ```

4. **Cleanup**
   ```dart
   collection
     ..resetFilters()
     ..resetMatchers()
     ..resetSort()
     ..actualize();
   ```

## 🚀 Advanced Features

### Dry Run
Check results without applying:
```dart
final dryRunState = collection.dryRun();
print(dryRunState.data);
```

### Partial Update
```dart
collection
  ..updateOriginalData(newData)
  ..actualize();
```

### Custom Operations
```dart
class CustomFilter<T> extends FilterAction<T> {
  CustomFilter({
    required String key,
    required bool Function(T) predicate,
  }) : super(key: key, predicate: predicate);
  
  // Additional logic
}
``` 