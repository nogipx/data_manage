import 'dart:async';

abstract class UseCase<T> {
  const UseCase();
  T run();
}

abstract class UseCaseAsync<T> extends UseCase<Future<T>> {
  const UseCaseAsync();
}
