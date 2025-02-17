import 'package:data_manage/data_collection.dart';

abstract class DataCollectionListener<T> {
  void onStateChanged(DataCollectionState<T> state);
  void onActualize(DataCollectionState<T> state);
}

class SimpleCollectionListener<T> implements DataCollectionListener<T> {
  final DataCollectionStateCallback<DataCollectionState<T>>? actualizeListener;
  final DataCollectionStateCallback<DataCollectionState<T>>? stateListener;

  const SimpleCollectionListener({
    this.actualizeListener,
    this.stateListener,
  });

  @override
  void onActualize(DataCollectionState<T> state) {
    actualizeListener?.call(state);
  }

  @override
  void onStateChanged(DataCollectionState<T> state) {
    stateListener?.call(state);
  }
}
