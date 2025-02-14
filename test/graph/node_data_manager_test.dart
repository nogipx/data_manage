import 'package:test/test.dart';
import 'package:data_manage/src/graph/data/node_data_managers/simple.dart';
import 'package:data_manage/src/graph/data/node_data_managers/lru_cache.dart';

void main() {
  group('SimpleNodeDataManager |', () {
    late SimpleNodeDataManager<String> manager;

    setUp(() {
      manager = SimpleNodeDataManager<String>();
    });

    test('initial_state_is_empty', () {
      expect(manager.data.isEmpty, isTrue);
      expect(manager.getMetrics()['size'], equals(0));
      expect(manager.getMetrics()['hits'], equals(0));
      expect(manager.getMetrics()['misses'], equals(0));
    });

    test('set_and_get_data', () {
      manager.set('node1', 'data1');
      expect(manager.get('node1'), equals('data1'));
      expect(manager.data['node1'], equals('data1'));
    });

    test('remove_data', () {
      manager.set('node1', 'data1');
      manager.remove('node1');
      expect(manager.get('node1'), isNull);
      expect(manager.data['node1'], isNull);
    });

    test('clear_data', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.clear();
      expect(manager.data.isEmpty, isTrue);
    });

    test('hit_miss_metrics', () {
      manager.set('node1', 'data1');

      // Hit
      manager.get('node1');
      manager.get('node1');

      // Miss
      manager.get('node2');

      final metrics = manager.getMetrics();
      expect(metrics['hits'], equals(2));
      expect(metrics['misses'], equals(1));
      expect(metrics['hitRate'], equals(2 / 3));
    });
  });

  group('LRUNodeDataManager |', () {
    late LRUNodeDataManager<String> manager;
    const maxSize = 3;

    setUp(() {
      manager = LRUNodeDataManager<String>(maxSize: maxSize);
    });

    test('initial_state_is_empty', () {
      expect(manager.data.isEmpty, isTrue);
      expect(manager.getMetrics()['size'], equals(0));
      expect(manager.getMetrics()['maxSize'], equals(maxSize));
    });

    test('respect_max_size_limit', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.set('node3', 'data3');
      manager.set('node4', 'data4'); // Should evict node1

      expect(manager.data.length, equals(maxSize));
      expect(manager.get('node1'), isNull);
      expect(manager.get('node2'), equals('data2'));
      expect(manager.get('node3'), equals('data3'));
      expect(manager.get('node4'), equals('data4'));
    });

    test('lru_order_is_maintained', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.set('node3', 'data3');

      // Access node1, making it most recently used
      manager.get('node1');

      // Add new node, should evict node2 (least recently used)
      manager.set('node4', 'data4');

      expect(manager.get('node1'), equals('data1'));
      expect(manager.get('node2'), isNull);
      expect(manager.get('node3'), equals('data3'));
      expect(manager.get('node4'), equals('data4'));
    });

    test('get_updates_lru_order', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.set('node3', 'data3');

      // Access nodes in reverse order
      manager.get('node1');
      manager.get('node2');
      manager.get('node3');

      // Add new node, should evict node1 (least recently used)
      manager.set('node4', 'data4');

      expect(manager.get('node1'), isNull);
      expect(manager.get('node2'), equals('data2'));
      expect(manager.get('node3'), equals('data3'));
      expect(manager.get('node4'), equals('data4'));
    });

    test('clear_resets_all_state', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.get('node1'); // Hit
      manager.get('node3'); // Miss

      manager.clear();

      final metrics = manager.getMetrics();
      expect(manager.data.isEmpty, isTrue);
      expect(metrics['hits'], equals(0));
      expect(metrics['misses'], equals(0));
      expect(metrics['size'], equals(0));
    });

    test('metrics_are_accurate', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');

      // Hits
      manager.get('node1');
      manager.get('node2');
      manager.get('node1');

      // Misses
      manager.get('node3');
      manager.get('node4');

      final metrics = manager.getMetrics();
      expect(metrics['hits'], equals(3));
      expect(metrics['misses'], equals(2));
      expect(metrics['hitRate'], equals(3 / 5));
      expect(metrics['size'], equals(2));
      expect(metrics['utilizationRate'], equals(2 / maxSize));
    });

    test('get_least_most_recently_used_keys', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.set('node3', 'data3');

      // Access node1, making it most recently used
      manager.get('node1');

      expect(manager.getLeastUsedKeys(), equals(['node2', 'node3', 'node1']));
      expect(manager.getMostRecentlyUsedKeys(), equals(['node1', 'node3', 'node2']));
    });
  });
}
