# 3.0.2

fix: add data_manage.dart global export file

# 3.0.1

feat: Added `dartdoc` to the project

# 3.0.0

BREAKING CHANGE: Removed all external dependencies
- Removed `equatable` in favor of manual equality implementation
- Removed `fast_immutable_collections` in favor of standard Dart collections
- Removed `freezed` and `freezed_annotation` in favor of manual state classes
- Removed `meta` package

feat: Enhanced core functionality
- Improved performance by reducing dependency overhead
- Significantly reduced package size
- Improved type safety with Dart's built-in features
- Enhanced test coverage for core functionality
- Optimized memory usage with built-in collections
- Simplified codebase for better maintainability

chore: Technical improvements
- Replaced immutable collections with Dart's `UnmodifiableMapView` and `UnmodifiableSetView`
- Rewritten equality comparisons using standard Dart
- Updated all state classes to use standard Dart features
- Enhanced documentation with pure Dart examples

# 2.2.2

fix: Improved DataCollection functionality
- Corrected AND/OR conditions application order
- Enhanced combination behavior for mixed matchers
- Fixed edge cases with empty data handling
- Improved test coverage for complex scenarios
- Added proper handling of empty datasets
- Improved applied filters tracking

docs: Enhanced documentation
- Added comprehensive guide for Data Collection
- Improved code examples with best practices
- Updated README with detailed feature descriptions
- Added technical documentation in English

# 2.2.1

BREAKING CHANGE: Removed multiple parents support
- Graph now strictly enforces single-parent hierarchy
- Attempting to add a second parent will throw StateError

refactor: Improved SubtreeView implementation
- Moved SubtreeView to a separate part file
- Fixed initialization to avoid recursion
- Improved code organization and encapsulation
- Added comprehensive documentation with usage examples

# 2.2.0

test: Enhanced graph traversal tests
- Tests now verify algorithm invariants instead of specific traversal order
- Added parent-child relationship validations
- Added level structure preservation checks for breadth-first traversal
- Improved test error messages with detailed descriptions

fix: Fixed root node display in graph string representation

# 2.1.0

refactor: Separated exports for better code organization

# 2.0.4

fix: Empty matchers now produce negative match

# 2.0.3

perf: Improved BFS performance by using Queue implementation

# 2.0.2

feat: Added new throttle features
- Added force confirming capability
- Added async support to willConfirm in throttle

# 2.0.0

BREAKING CHANGE: Renamed Tree to IGraph for better semantic clarity

chore: Updated dependencies

# 1.3.8

feat: Enhanced tree functionality
- Added subtree selection functionality
- Optimized node storage by saving edges list only for nodes with children

# 1.3.7

fix: Fixed batch handling to prevent saving unconfirmed batches

# 1.3.6

fix: Improved error handling by passing batch when error occurs

# 1.3.5

fix: Enhanced batch confirmation handling

# 1.3.4

BREAKING CHANGE: Renamed delegate methods for better clarity

# 1.3.3

feat: Added delegate for throttle aggregator
fix: Improved confirming process with try/catch handling

# 1.3.2

feat: Added support for waiting during batch confirmation

# 1.3.1

chore: Fixed exports organization

# 1.3.0

feat: Added batch throttling aggregator

# 1.2.5

refactor: Improved tree structure
- Separated tree interfaces
- Added protection against hierarchy changes in existing tree during edge addition

# 1.2.4

feat: Added typedefs for business case decoupling

# 1.2.3

feat: Added data collection listener

# 1.2.2

feat: Added method to clear tree data

# 1.2.1

fix: Fixed data collection state listeners behavior

# 1.2.0

BREAKING CHANGE: Updated fast_immutable_collections from `^8.1.0` to `^9.1.5`

feat: Added tests for data_collection functionality