// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SelectionState<T> {
  Set<T> get selected => throw _privateConstructorUsedError;
  Set<T> get staging => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SelectionStateCopyWith<T, SelectionState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectionStateCopyWith<T, $Res> {
  factory $SelectionStateCopyWith(
          SelectionState<T> value, $Res Function(SelectionState<T>) then) =
      _$SelectionStateCopyWithImpl<T, $Res, SelectionState<T>>;
  @useResult
  $Res call({Set<T> selected, Set<T> staging});
}

/// @nodoc
class _$SelectionStateCopyWithImpl<T, $Res, $Val extends SelectionState<T>>
    implements $SelectionStateCopyWith<T, $Res> {
  _$SelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selected = null,
    Object? staging = null,
  }) {
    return _then(_value.copyWith(
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as Set<T>,
      staging: null == staging
          ? _value.staging
          : staging // ignore: cast_nullable_to_non_nullable
              as Set<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectionUpdatedStateImplCopyWith<T, $Res>
    implements $SelectionStateCopyWith<T, $Res> {
  factory _$$SelectionUpdatedStateImplCopyWith(
          _$SelectionUpdatedStateImpl<T> value,
          $Res Function(_$SelectionUpdatedStateImpl<T>) then) =
      __$$SelectionUpdatedStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({Set<T> selected, Set<T> staging});
}

/// @nodoc
class __$$SelectionUpdatedStateImplCopyWithImpl<T, $Res>
    extends _$SelectionStateCopyWithImpl<T, $Res,
        _$SelectionUpdatedStateImpl<T>>
    implements _$$SelectionUpdatedStateImplCopyWith<T, $Res> {
  __$$SelectionUpdatedStateImplCopyWithImpl(
      _$SelectionUpdatedStateImpl<T> _value,
      $Res Function(_$SelectionUpdatedStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selected = null,
    Object? staging = null,
  }) {
    return _then(_$SelectionUpdatedStateImpl<T>(
      selected: null == selected
          ? _value._selected
          : selected // ignore: cast_nullable_to_non_nullable
              as Set<T>,
      staging: null == staging
          ? _value._staging
          : staging // ignore: cast_nullable_to_non_nullable
              as Set<T>,
    ));
  }
}

/// @nodoc

class _$SelectionUpdatedStateImpl<T> extends SelectionUpdatedState<T> {
  const _$SelectionUpdatedStateImpl(
      {required final Set<T> selected, required final Set<T> staging})
      : _selected = selected,
        _staging = staging,
        super._();

  final Set<T> _selected;
  @override
  Set<T> get selected {
    if (_selected is EqualUnmodifiableSetView) return _selected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selected);
  }

  final Set<T> _staging;
  @override
  Set<T> get staging {
    if (_staging is EqualUnmodifiableSetView) return _staging;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_staging);
  }

  @override
  String toString() {
    return 'SelectionState<$T>(selected: $selected, staging: $staging)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectionUpdatedStateImpl<T> &&
            const DeepCollectionEquality().equals(other._selected, _selected) &&
            const DeepCollectionEquality().equals(other._staging, _staging));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_selected),
      const DeepCollectionEquality().hash(_staging));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectionUpdatedStateImplCopyWith<T, _$SelectionUpdatedStateImpl<T>>
      get copyWith => __$$SelectionUpdatedStateImplCopyWithImpl<T,
          _$SelectionUpdatedStateImpl<T>>(this, _$identity);
}

abstract class SelectionUpdatedState<T> extends SelectionState<T> {
  const factory SelectionUpdatedState(
      {required final Set<T> selected,
      required final Set<T> staging}) = _$SelectionUpdatedStateImpl<T>;
  const SelectionUpdatedState._() : super._();

  @override
  Set<T> get selected;
  @override
  Set<T> get staging;
  @override
  @JsonKey(ignore: true)
  _$$SelectionUpdatedStateImplCopyWith<T, _$SelectionUpdatedStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
