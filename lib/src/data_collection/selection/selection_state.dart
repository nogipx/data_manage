import 'package:freezed_annotation/freezed_annotation.dart';

part 'selection_state.freezed.dart';

@freezed
class SelectionState<T> with _$SelectionState<T> {
  const SelectionState._();

  const factory SelectionState({
    required Set<T> selected,
    required Set<T> staging,
  }) = SelectionUpdatedState;

  bool get hasSelection => selected.isNotEmpty;
}
