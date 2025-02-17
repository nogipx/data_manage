# 3.0.0
### Breaking Changes
- Removed ALL external dependencies
  * Removed `equatable` in favor of manual equality implementation
  * Removed `fast_immutable_collections` in favor of standard Dart collections
  * Removed `freezed` and `freezed_annotation` in favor of manual state classes
  * Removed `meta` package
- Changed internal implementation to use standard Dart collections
  * Replaced `IMap` with `UnmodifiableMapView`
  * Replaced `ISet` with `UnmodifiableSetView`
  * Updated all state classes to use standard Dart features

### Improvements
- Improved performance by reducing dependency overhead
- Significantly reduced package size
- Enhanced type safety with Dart's built-in features
- Improved test coverage for core functionality

### Technical Details
- Rewritten equality comparisons using standard Dart
- Optimized memory usage with built-in collections
- Simplified codebase for better maintainability
- Enhanced documentation with pure Dart examples

### Major Changes
- Removed external dependencies (`equatable`, `fast_immutable_collections`, `freezed`, `meta`)
- Simplified codebase to use only standard Dart features
- Improved performance by reducing dependency overhead
- Replaced immutable collections with Dart's `UnmodifiableMapView` and `UnmodifiableSetView`
- Rewrote state classes to use pure Dart implementations

### Technical Details
- Removed generated files and code
- Updated equality comparisons to use standard Dart implementations
- Optimized memory usage with built-in Dart collections
- Maintained full backward compatibility
- Enhanced type safety with Dart's built-in features
- docs: fixed docs

# 2.2.2
- fix!: improved matcher logic in DataCollection
  - corrected AND/OR conditions application order
  - enhanced combination behavior for mixed matchers
  - fixed edge cases with empty data handling
  - improved test coverage for complex scenarios
- fix: optimized filter behavior with empty data
  - added proper handling of empty datasets
  - improved applied filters tracking
  - enhanced test cases for edge conditions
- docs: enhanced documentation and examples
  - added comprehensive guide for Data Collection
  - improved code examples with best practices
  - updated README with detailed feature descriptions
  - added technical documentation in English

# 2.2.1
- refactor: improved SubtreeView implementation
  - moved SubtreeView to a separate part file
  - fixed initialization to avoid recursion
  - improved code organization and encapsulation
  - added comprehensive documentation with usage examples
- refactor!: removed multiple parents support
  - graph now strictly enforces single-parent hierarchy
  - attempting to add a second parent will throw StateError
  - this change improves data consistency and simplifies tree traversal

# 2.2.0
- refactor: enhanced graph traversal tests stability
  - tests now verify algorithm invariants instead of specific traversal order
  - added parent-child relationship validations
  - added level structure preservation checks for breadth-first traversal
  - improved test error messages with detailed descriptions
- fix: fixed root node display in graph string representation

# 2.1.0
- fix: separate exports

# 2.0.4
- fix: empty matchers produce negative match now

# 2.0.3
- fix: use Queue for BFS to improve perfomance

# 2.0.2
- fix: add async to willConfirm in throttle
- feat: add force confirming

# 2.0.0
* feat!: breaking change: rename Tree to IGraph
* chore: update dependencies

# 1.3.8
* feat(tree): add subtree selection
* feat(tree): save edges list for node only if node has children

# 1.3.7
* fix: do not try to save not confirmed batch

# 1.3.6
* fix: pass batch when error happened

# 1.3.5
* fix: careful handle confirming batch

# 1.3.4
* feat!: rename delegate methods

# 1.3.3
* fix: wrap confirming wit try/catch
* feat: make delegate for throttle aggregator

# 1.3.2
* feat: add waiting for confirming batch

# 1.3.1
* fix: exports

# 1.3.0
* add batch throttling aggregator

# 1.2.5
* separate tree interfaces
* not allow to change hierarchy of present tree while adding edges

# 1.2.4
* add typedefs for decoupling for business cases

# 1.2.3
* add data collection listener

# 1.2.2
* add method to clear tree data

# 1.2.1
* fix bug with data collection state listeners

# 1.2.0
* bump fast_immutable_collections from `^8.1.0` to `^9.1.5`
* add tests for data_collection functionality