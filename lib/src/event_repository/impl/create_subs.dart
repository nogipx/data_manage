import 'dart:async';

import '../_index.dart';
import 'event_subs_manager.dart';

IEventsSubscriptions<T> createRepositoryEventsSubscriptions<T>(
  IEventRepository<T> repository, {
  StreamTransformer<T, T>? transformAll,
  StreamModifier<T>? modifyAll,
}) =>
    EventsSubscriptions<T>(repository.stream,
        transformAll: transformAll, modifyAll: modifyAll);
