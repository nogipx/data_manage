typedef DataCollectionStateCallback<T> = void Function(T state);

typedef DataCollectionPredicate<T> = bool Function(T item);

abstract class DataCollectionUseCase<T> {
  const DataCollectionUseCase();
  T run();
}
