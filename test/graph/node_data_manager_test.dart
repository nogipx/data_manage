import 'package:test/test.dart';
import 'package:data_manage/src/graph/data/node_data_managers/simple.dart';
import 'package:data_manage/src/graph/data/node_data_managers/lru_cache.dart';

void main() {
  group('SimpleNodeDataManager |', () {
    late SimpleNodeDataManager<String> manager;

    setUp(() {
      manager = SimpleNodeDataManager<String>();
    });

    test('Initial state is empty', () {
      expect(manager.data.isEmpty, isTrue);
      expect(manager.getMetrics()['size'], equals(0));
      expect(manager.getMetrics()['hits'], equals(0));
      expect(manager.getMetrics()['misses'], equals(0));
    });

    test('Set and get data', () {
      manager.set('node1', 'data1');
      expect(manager.get('node1'), equals('data1'));
      expect(manager.data['node1'], equals('data1'));
    });

    test('Remove data', () {
      manager.set('node1', 'data1');
      manager.remove('node1');
      expect(manager.get('node1'), isNull);
      expect(manager.data['node1'], isNull);
    });

    test('Clear data', () {
      manager.set('node1', 'data1');
      manager.set('node2', 'data2');
      manager.clear();
      expect(manager.data.isEmpty, isTrue);
    });

    test('Hit/miss metrics', () {
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

    test('Initial state is empty', () {
      expect(manager.data.isEmpty, isTrue);
      expect(manager.getMetrics()['size'], equals(0));
      expect(manager.getMetrics()['maxSize'], equals(maxSize));
    });

    test('Respect max size limit', () {
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

    test('LRU order is maintained', () {
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

    test('Get updates LRU order', () {
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

    test('Clear resets all state', () {
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

    test('Metrics are accurate', () {
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

    test('Get least/most recently used keys', () {
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
