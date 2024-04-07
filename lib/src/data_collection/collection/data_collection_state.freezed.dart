// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_collection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DataCollectionState<T> {
  Iterable<T> get originalData => throw _privateConstructorUsedError;
  Iterable<T> get data => throw _privateConstructorUsedError;
  IMap<String, FilterAction<T>> get filters =>
      throw _privateConstructorUsedError;
  IMap<String, MatchAction<T>> get matchers =>
      throw _privateConstructorUsedError;
  SortAction<T>? get sort => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        initial,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        loading,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        updated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataCollectionInitialState<T> value) initial,
    required TResult Function(DataCollectionLoadingState<T> value) loading,
    required TResult Function(DataCollectionUpdatedState<T> value) updated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DataCollectionInitialState<T> value)? initial,
    TResult? Function(DataCollectionLoadingState<T> value)? loading,
    TResult? Function(DataCollectionUpdatedState<T> value)? updated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataCollectionInitialState<T> value)? initial,
    TResult Function(DataCollectionLoadingState<T> value)? loading,
    TResult Function(DataCollectionUpdatedState<T> value)? updated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataCollectionStateCopyWith<T, DataCollectionState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataCollectionStateCopyWith<T, $Res> {
  factory $DataCollectionStateCopyWith(DataCollectionState<T> value,
          $Res Function(DataCollectionState<T>) then) =
      _$DataCollectionStateCopyWithImpl<T, $Res, DataCollectionState<T>>;
  @useResult
  $Res call(
      {Iterable<T> originalData,
      Iterable<T> data,
      IMap<String, FilterAction<T>> filters,
      IMap<String, MatchAction<T>> matchers,
      SortAction<T>? sort});
}

/// @nodoc
class _$DataCollectionStateCopyWithImpl<T, $Res,
        $Val extends DataCollectionState<T>>
    implements $DataCollectionStateCopyWith<T, $Res> {
  _$DataCollectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalData = null,
    Object? data = null,
    Object? filters = null,
    Object? matchers = null,
    Object? sort = freezed,
  }) {
    return _then(_value.copyWith(
      originalData: null == originalData
          ? _value.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as IMap<String, FilterAction<T>>,
      matchers: null == matchers
          ? _value.matchers
          : matchers // ignore: cast_nullable_to_non_nullable
              as IMap<String, MatchAction<T>>,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortAction<T>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataCollectionInitialStateImplCopyWith<T, $Res>
    implements $DataCollectionStateCopyWith<T, $Res> {
  factory _$$DataCollectionInitialStateImplCopyWith(
          _$DataCollectionInitialStateImpl<T> value,
          $Res Function(_$DataCollectionInitialStateImpl<T>) then) =
      __$$DataCollectionInitialStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {Iterable<T> originalData,
      Iterable<T> data,
      IMap<String, FilterAction<T>> filters,
      IMap<String, MatchAction<T>> matchers,
      SortAction<T>? sort});
}

/// @nodoc
class __$$DataCollectionInitialStateImplCopyWithImpl<T, $Res>
    extends _$DataCollectionStateCopyWithImpl<T, $Res,
        _$DataCollectionInitialStateImpl<T>>
    implements _$$DataCollectionInitialStateImplCopyWith<T, $Res> {
  __$$DataCollectionInitialStateImplCopyWithImpl(
      _$DataCollectionInitialStateImpl<T> _value,
      $Res Function(_$DataCollectionInitialStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalData = null,
    Object? data = null,
    Object? filters = null,
    Object? matchers = null,
    Object? sort = freezed,
  }) {
    return _then(_$DataCollectionInitialStateImpl<T>(
      originalData: null == originalData
          ? _value.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as IMap<String, FilterAction<T>>,
      matchers: null == matchers
          ? _value.matchers
          : matchers // ignore: cast_nullable_to_non_nullable
              as IMap<String, MatchAction<T>>,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortAction<T>?,
    ));
  }
}

/// @nodoc

class _$DataCollectionInitialStateImpl<T>
    extends DataCollectionInitialState<T> {
  const _$DataCollectionInitialStateImpl(
      {required this.originalData,
      required this.data,
      this.filters = const IMapConst({}),
      this.matchers = const IMapConst({}),
      this.sort})
      : super._();

  @override
  final Iterable<T> originalData;
  @override
  final Iterable<T> data;
  @override
  @JsonKey()
  final IMap<String, FilterAction<T>> filters;
  @override
  @JsonKey()
  final IMap<String, MatchAction<T>> matchers;
  @override
  final SortAction<T>? sort;

  @override
  String toString() {
    return 'DataCollectionState<$T>.initial(originalData: $originalData, data: $data, filters: $filters, matchers: $matchers, sort: $sort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataCollectionInitialStateImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.originalData, originalData) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.matchers, matchers) ||
                other.matchers == matchers) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(originalData),
      const DeepCollectionEquality().hash(data),
      filters,
      matchers,
      sort);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataCollectionInitialStateImplCopyWith<T,
          _$DataCollectionInitialStateImpl<T>>
      get copyWith => __$$DataCollectionInitialStateImplCopyWithImpl<T,
          _$DataCollectionInitialStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        initial,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        loading,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        updated,
  }) {
    return initial(originalData, data, filters, matchers, sort);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
  }) {
    return initial?.call(originalData, data, filters, matchers, sort);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(originalData, data, filters, matchers, sort);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataCollectionInitialState<T> value) initial,
    required TResult Function(DataCollectionLoadingState<T> value) loading,
    required TResult Function(DataCollectionUpdatedState<T> value) updated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DataCollectionInitialState<T> value)? initial,
    TResult? Function(DataCollectionLoadingState<T> value)? loading,
    TResult? Function(DataCollectionUpdatedState<T> value)? updated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataCollectionInitialState<T> value)? initial,
    TResult Function(DataCollectionLoadingState<T> value)? loading,
    TResult Function(DataCollectionUpdatedState<T> value)? updated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class DataCollectionInitialState<T> extends DataCollectionState<T> {
  const factory DataCollectionInitialState(
      {required final Iterable<T> originalData,
      required final Iterable<T> data,
      final IMap<String, FilterAction<T>> filters,
      final IMap<String, MatchAction<T>> matchers,
      final SortAction<T>? sort}) = _$DataCollectionInitialStateImpl<T>;
  const DataCollectionInitialState._() : super._();

  @override
  Iterable<T> get originalData;
  @override
  Iterable<T> get data;
  @override
  IMap<String, FilterAction<T>> get filters;
  @override
  IMap<String, MatchAction<T>> get matchers;
  @override
  SortAction<T>? get sort;
  @override
  @JsonKey(ignore: true)
  _$$DataCollectionInitialStateImplCopyWith<T,
          _$DataCollectionInitialStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DataCollectionLoadingStateImplCopyWith<T, $Res>
    implements $DataCollectionStateCopyWith<T, $Res> {
  factory _$$DataCollectionLoadingStateImplCopyWith(
          _$DataCollectionLoadingStateImpl<T> value,
          $Res Function(_$DataCollectionLoadingStateImpl<T>) then) =
      __$$DataCollectionLoadingStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {Iterable<T> originalData,
      Iterable<T> data,
      IMap<String, FilterAction<T>> filters,
      IMap<String, MatchAction<T>> matchers,
      SortAction<T>? sort});
}

/// @nodoc
class __$$DataCollectionLoadingStateImplCopyWithImpl<T, $Res>
    extends _$DataCollectionStateCopyWithImpl<T, $Res,
        _$DataCollectionLoadingStateImpl<T>>
    implements _$$DataCollectionLoadingStateImplCopyWith<T, $Res> {
  __$$DataCollectionLoadingStateImplCopyWithImpl(
      _$DataCollectionLoadingStateImpl<T> _value,
      $Res Function(_$DataCollectionLoadingStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalData = null,
    Object? data = null,
    Object? filters = null,
    Object? matchers = null,
    Object? sort = freezed,
  }) {
    return _then(_$DataCollectionLoadingStateImpl<T>(
      originalData: null == originalData
          ? _value.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as IMap<String, FilterAction<T>>,
      matchers: null == matchers
          ? _value.matchers
          : matchers // ignore: cast_nullable_to_non_nullable
              as IMap<String, MatchAction<T>>,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortAction<T>?,
    ));
  }
}

/// @nodoc

class _$DataCollectionLoadingStateImpl<T>
    extends DataCollectionLoadingState<T> {
  const _$DataCollectionLoadingStateImpl(
      {required this.originalData,
      required this.data,
      required this.filters,
      required this.matchers,
      this.sort})
      : super._();

  @override
  final Iterable<T> originalData;
  @override
  final Iterable<T> data;
  @override
  final IMap<String, FilterAction<T>> filters;
  @override
  final IMap<String, MatchAction<T>> matchers;
  @override
  final SortAction<T>? sort;

  @override
  String toString() {
    return 'DataCollectionState<$T>.loading(originalData: $originalData, data: $data, filters: $filters, matchers: $matchers, sort: $sort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataCollectionLoadingStateImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.originalData, originalData) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.matchers, matchers) ||
                other.matchers == matchers) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(originalData),
      const DeepCollectionEquality().hash(data),
      filters,
      matchers,
      sort);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataCollectionLoadingStateImplCopyWith<T,
          _$DataCollectionLoadingStateImpl<T>>
      get copyWith => __$$DataCollectionLoadingStateImplCopyWithImpl<T,
          _$DataCollectionLoadingStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        initial,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        loading,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        updated,
  }) {
    return loading(originalData, data, filters, matchers, sort);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
  }) {
    return loading?.call(originalData, data, filters, matchers, sort);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(originalData, data, filters, matchers, sort);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataCollectionInitialState<T> value) initial,
    required TResult Function(DataCollectionLoadingState<T> value) loading,
    required TResult Function(DataCollectionUpdatedState<T> value) updated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DataCollectionInitialState<T> value)? initial,
    TResult? Function(DataCollectionLoadingState<T> value)? loading,
    TResult? Function(DataCollectionUpdatedState<T> value)? updated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataCollectionInitialState<T> value)? initial,
    TResult Function(DataCollectionLoadingState<T> value)? loading,
    TResult Function(DataCollectionUpdatedState<T> value)? updated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DataCollectionLoadingState<T> extends DataCollectionState<T> {
  const factory DataCollectionLoadingState(
      {required final Iterable<T> originalData,
      required final Iterable<T> data,
      required final IMap<String, FilterAction<T>> filters,
      required final IMap<String, MatchAction<T>> matchers,
      final SortAction<T>? sort}) = _$DataCollectionLoadingStateImpl<T>;
  const DataCollectionLoadingState._() : super._();

  @override
  Iterable<T> get originalData;
  @override
  Iterable<T> get data;
  @override
  IMap<String, FilterAction<T>> get filters;
  @override
  IMap<String, MatchAction<T>> get matchers;
  @override
  SortAction<T>? get sort;
  @override
  @JsonKey(ignore: true)
  _$$DataCollectionLoadingStateImplCopyWith<T,
          _$DataCollectionLoadingStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DataCollectionUpdatedStateImplCopyWith<T, $Res>
    implements $DataCollectionStateCopyWith<T, $Res> {
  factory _$$DataCollectionUpdatedStateImplCopyWith(
          _$DataCollectionUpdatedStateImpl<T> value,
          $Res Function(_$DataCollectionUpdatedStateImpl<T>) then) =
      __$$DataCollectionUpdatedStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {Iterable<T> originalData,
      Iterable<T> data,
      IMap<String, FilterAction<T>> filters,
      IMap<String, MatchAction<T>> matchers,
      SortAction<T>? sort});
}

/// @nodoc
class __$$DataCollectionUpdatedStateImplCopyWithImpl<T, $Res>
    extends _$DataCollectionStateCopyWithImpl<T, $Res,
        _$DataCollectionUpdatedStateImpl<T>>
    implements _$$DataCollectionUpdatedStateImplCopyWith<T, $Res> {
  __$$DataCollectionUpdatedStateImplCopyWithImpl(
      _$DataCollectionUpdatedStateImpl<T> _value,
      $Res Function(_$DataCollectionUpdatedStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalData = null,
    Object? data = null,
    Object? filters = null,
    Object? matchers = null,
    Object? sort = freezed,
  }) {
    return _then(_$DataCollectionUpdatedStateImpl<T>(
      originalData: null == originalData
          ? _value.originalData
          : originalData // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Iterable<T>,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as IMap<String, FilterAction<T>>,
      matchers: null == matchers
          ? _value.matchers
          : matchers // ignore: cast_nullable_to_non_nullable
              as IMap<String, MatchAction<T>>,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortAction<T>?,
    ));
  }
}

/// @nodoc

class _$DataCollectionUpdatedStateImpl<T>
    extends DataCollectionUpdatedState<T> {
  const _$DataCollectionUpdatedStateImpl(
      {required this.originalData,
      required this.data,
      required this.filters,
      required this.matchers,
      this.sort})
      : super._();

  @override
  final Iterable<T> originalData;
  @override
  final Iterable<T> data;
  @override
  final IMap<String, FilterAction<T>> filters;
  @override
  final IMap<String, MatchAction<T>> matchers;
  @override
  final SortAction<T>? sort;

  @override
  String toString() {
    return 'DataCollectionState<$T>.updated(originalData: $originalData, data: $data, filters: $filters, matchers: $matchers, sort: $sort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataCollectionUpdatedStateImpl<T> &&
            const DeepCollectionEquality()
                .equals(other.originalData, originalData) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.matchers, matchers) ||
                other.matchers == matchers) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(originalData),
      const DeepCollectionEquality().hash(data),
      filters,
      matchers,
      sort);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataCollectionUpdatedStateImplCopyWith<T,
          _$DataCollectionUpdatedStateImpl<T>>
      get copyWith => __$$DataCollectionUpdatedStateImplCopyWithImpl<T,
          _$DataCollectionUpdatedStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        initial,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        loading,
    required TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)
        updated,
  }) {
    return updated(originalData, data, filters, matchers, sort);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult? Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
  }) {
    return updated?.call(originalData, data, filters, matchers, sort);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        initial,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        loading,
    TResult Function(
            Iterable<T> originalData,
            Iterable<T> data,
            IMap<String, FilterAction<T>> filters,
            IMap<String, MatchAction<T>> matchers,
            SortAction<T>? sort)?
        updated,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(originalData, data, filters, matchers, sort);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataCollectionInitialState<T> value) initial,
    required TResult Function(DataCollectionLoadingState<T> value) loading,
    required TResult Function(DataCollectionUpdatedState<T> value) updated,
  }) {
    return updated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DataCollectionInitialState<T> value)? initial,
    TResult? Function(DataCollectionLoadingState<T> value)? loading,
    TResult? Function(DataCollectionUpdatedState<T> value)? updated,
  }) {
    return updated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataCollectionInitialState<T> value)? initial,
    TResult Function(DataCollectionLoadingState<T> value)? loading,
    TResult Function(DataCollectionUpdatedState<T> value)? updated,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(this);
    }
    return orElse();
  }
}

abstract class DataCollectionUpdatedState<T> extends DataCollectionState<T> {
  const factory DataCollectionUpdatedState(
      {required final Iterable<T> originalData,
      required final Iterable<T> data,
      required final IMap<String, FilterAction<T>> filters,
      required final IMap<String, MatchAction<T>> matchers,
      final SortAction<T>? sort}) = _$DataCollectionUpdatedStateImpl<T>;
  const DataCollectionUpdatedState._() : super._();

  @override
  Iterable<T> get originalData;
  @override
  Iterable<T> get data;
  @override
  IMap<String, FilterAction<T>> get filters;
  @override
  IMap<String, MatchAction<T>> get matchers;
  @override
  SortAction<T>? get sort;
  @override
  @JsonKey(ignore: true)
  _$$DataCollectionUpdatedStateImplCopyWith<T,
          _$DataCollectionUpdatedStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
