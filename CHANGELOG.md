# [2.1.0]
- fix: separate exports

# [2.0.4]
- fix: empty matchers produce negative match now

# [2.0.3]
- fix: use Queue for BFS to improve perfomance

# [2.0.2]
- fix: add async to willConfirm in throttle
- feat: add force confirming

# [2.0.0]
* feat!: breaking change: rename Tree to IGraph
* chore: update dependencies

# [1.3.8]
* feat(tree): add subtree selection
* feat(tree): save edges list for node only if node has children

# [1.3.7]
* fix: do not try to save not confirmed batch

# [1.3.6]
* fix: pass batch when error happened

# [1.3.5]
* fix: careful handle confirming batch

# [1.3.4]
* feat!: rename delegate methods

# [1.3.3]
* fix: wrap confirming wit try/catch
* feat: make delegate for throttle aggregator

# [1.3.2]
* feat: add waiting for confirming batch

# [1.3.1]
* fix: exports

# [1.3.0]
* add batch throttling aggregator

# [1.2.5]
* separate tree interfaces
* not allow to change hierarchy of present tree while adding edges

# [1.2.4]
* add typedefs for decoupling for business cases

# [1.2.3]
* add data collection listener

# [1.2.2]
* add method to clear tree data

# [1.2.1]
* fix bug with data collection state listeners

# [1.2.0]
* bump fast_immutable_collections from `^8.1.0` to `^9.1.5`
* add tests for data_collection functionality