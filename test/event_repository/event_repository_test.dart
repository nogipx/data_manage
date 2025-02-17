import 'dart:async';

import 'package:test/test.dart';
import 'package:data_manage/src/event_repository/_index.dart';

void main() {
  group('Event Repository', () {
    // Тестируем основное наблюдаемое поведение: управление событиями
    group('event management', () {
      late TestEventRepository sut; // system under test

      setUp(() {
        sut = TestEventRepository();
      });

      tearDown(() async {
        await sut.dispose();
      });

      test('delivers event to all subscribers', () async {
        // Arrange
        final event = SimpleTestEvent(data: 'test_data');
        final receivedEvents = StreamController<TestEventBase>();

        // Act
        final subscription = sut.stream.listen(receivedEvents.add);
        sut.addEvent(event: event);

        // Assert
        await expectLater(
          receivedEvents.stream,
          emits(event),
        );

        // Cleanup
        await subscription.cancel();
        await receivedEvents.close();
      });

      test('filters events by type', () async {
        // Arrange
        final targetEvent = NumericTestEvent(data: 42);
        final noiseEvent = StringTestEvent(data: 'noise');
        final receivedEvents = StreamController<NumericTestEvent>();

        // Act
        final subscription = sut.on<NumericTestEvent>().listen(receivedEvents.add);
        sut.addEvent(event: targetEvent);
        sut.addEvent(event: noiseEvent);

        // Assert
        await expectLater(
          receivedEvents.stream,
          emits(targetEvent),
        );

        // Cleanup
        await subscription.cancel();
        await receivedEvents.close();
      });

      test('prevents adding events after disposal', () async {
        // Arrange
        await sut.dispose();

        // Act & Assert
        expect(
          () => sut.addEvent(event: SimpleTestEvent(data: 'test')),
          throwsStateError,
        );
      });
    });
  });

  group('Event Subscriptions', () {
    // Тестируем основное наблюдаемое поведение: управление подписками
    group('subscription management', () {
      late TestEventRepository repository;
      late IEventsSubscriptions<TestEventBase> sut;

      setUp(() {
        repository = TestEventRepository();
        sut = createRepositoryEventsSubscriptions(repository);
      });

      tearDown(() async {
        await sut.dispose();
        await repository.dispose();
      });

      test('delivers events to type-specific handlers', () async {
        // Arrange
        final event = NumericTestEvent(data: 42);
        final receivedEvents = <NumericTestEvent>[];

        // Act
        final subscription = sut.subscribe<NumericTestEvent>((e) => receivedEvents.add(e));
        repository.addEvent(event: event);

        // Assert
        await Future<void>.delayed(Duration.zero);
        expect(receivedEvents, [event]);

        // Cleanup
        await subscription.cancel();
      });

      test('stops delivery after subscription cancellation', () async {
        // Arrange
        final event = NumericTestEvent(data: 42);
        final receivedEvents = <NumericTestEvent>[];

        // Act
        final subscription = sut.subscribe<NumericTestEvent>((e) => receivedEvents.add(e));
        sut.cancel<NumericTestEvent>();
        repository.addEvent(event: event);

        // Assert
        await Future<void>.delayed(Duration.zero);
        expect(receivedEvents, isEmpty);

        // Cleanup
        await subscription.cancel();
      });

      test('applies stream transformations', () async {
        // Arrange
        final receivedEvents = <NumericTestEvent>[];
        final duplicateEvent = NumericTestEvent(data: 42);

        // Act
        final subscription = sut.subscribe<NumericTestEvent>(
          (e) => receivedEvents.add(e),
          modify: (stream) => stream.distinct(),
        );

        repository.addEvent(event: duplicateEvent);
        repository.addEvent(event: duplicateEvent); // Дубликат

        // Assert
        await Future<void>.delayed(Duration.zero);
        expect(receivedEvents.length, 1);

        // Cleanup
        await subscription.cancel();
      });
    });
  });
}

// Тестовые события
base class TestEventBase extends IEventBase<dynamic> {
  const TestEventBase({required super.data});
}

base class SimpleTestEvent extends TestEventBase {
  const SimpleTestEvent({required super.data});
}

base class NumericTestEvent extends TestEventBase {
  const NumericTestEvent({required int? data}) : super(data: data);
}

base class StringTestEvent extends TestEventBase {
  const StringTestEvent({required String? data}) : super(data: data);
}

class TestEventRepository with EventRepositoryMixin<TestEventBase> {}
