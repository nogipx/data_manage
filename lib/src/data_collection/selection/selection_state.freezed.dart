// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
abstract class _$$SelectionUpdatedStateCopyWith<T, $Res>
    implements $SelectionStateCopyWith<T, $Res> {
  factory _$$SelectionUpdatedStateCopyWith(_$SelectionUpdatedState<T> value,
          $Res Function(_$SelectionUpdatedState<T>) then) =
      __$$SelectionUpdatedStateCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({Set<T> selected, Set<T> staging});
}

/// @nodoc
class __$$SelectionUpdatedStateCopyWithImpl<T, $Res>
    extends _$SelectionStateCopyWithImpl<T, $Res, _$SelectionUpdatedState<T>>
    implements _$$SelectionUpdatedStateCopyWith<T, $Res> {
  __$$SelectionUpdatedStateCopyWithImpl(_$SelectionUpdatedState<T> _value,
      $Res Function(_$SelectionUpdatedState<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selected = null,
    Object? staging = null,
  }) {
    return _then(_$SelectionUpdatedState<T>(
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

class _$SelectionUpdatedState<T> extends SelectionUpdatedState<T> {
  const _$SelectionUpdatedState(
      {required final Set<T> selected, required final Set<T> staging})
      : _selected = selected,
        _staging = staging,
        super._();

  final Set<T> _selected;
  @override
  Set<T> get selected {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selected);
  }

  final Set<T> _staging;
  @override
  Set<T> get staging {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_staging);
  }

  @override
  String toString() {
    return 'SelectionState<$T>(selected: $selected, staging: $staging)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectionUpdatedState<T> &&
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
  _$$SelectionUpdatedStateCopyWith<T, _$SelectionUpdatedState<T>>
      get copyWith =>
          __$$SelectionUpdatedStateCopyWithImpl<T, _$SelectionUpdatedState<T>>(
              this, _$identity);
}

abstract class SelectionUpdatedState<T> extends SelectionState<T> {
  const factory SelectionUpdatedState(
      {required final Set<T> selected,
      required final Set<T> staging}) = _$SelectionUpdatedState<T>;
  const SelectionUpdatedState._() : super._();

  @override
  Set<T> get selected;
  @override
  Set<T> get staging;
  @override
  @JsonKey(ignore: true)
  _$$SelectionUpdatedStateCopyWith<T, _$SelectionUpdatedState<T>>
      get copyWith => throw _privateConstructorUsedError;
}
