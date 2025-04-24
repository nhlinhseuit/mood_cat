// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoodData {
  String get mood;
  String get content;
  List<String> get imageUrls;
  UserData get user;
  int get createdAt;

  /// Create a copy of MoodData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MoodDataCopyWith<MoodData> get copyWith =>
      _$MoodDataCopyWithImpl<MoodData>(this as MoodData, _$identity);

  /// Serializes this MoodData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MoodData &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mood, content,
      const DeepCollectionEquality().hash(imageUrls), user, createdAt);

  @override
  String toString() {
    return 'MoodData(mood: $mood, content: $content, imageUrls: $imageUrls, user: $user, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $MoodDataCopyWith<$Res> {
  factory $MoodDataCopyWith(MoodData value, $Res Function(MoodData) _then) =
      _$MoodDataCopyWithImpl;
  @useResult
  $Res call(
      {String mood,
      String content,
      List<String> imageUrls,
      UserData user,
      int createdAt});

  $UserDataCopyWith<$Res> get user;
}

/// @nodoc
class _$MoodDataCopyWithImpl<$Res> implements $MoodDataCopyWith<$Res> {
  _$MoodDataCopyWithImpl(this._self, this._then);

  final MoodData _self;
  final $Res Function(MoodData) _then;

  /// Create a copy of MoodData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mood = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? user = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      mood: null == mood
          ? _self.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of MoodData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get user {
    return $UserDataCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _MoodData extends MoodData {
  const _MoodData(
      {this.mood = '',
      this.content = '',
      final List<String> imageUrls = const [],
      this.user = const UserData(),
      this.createdAt = 0})
      : _imageUrls = imageUrls,
        super._();
  factory _MoodData.fromJson(Map<String, dynamic> json) =>
      _$MoodDataFromJson(json);

  @override
  @JsonKey()
  final String mood;
  @override
  @JsonKey()
  final String content;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  final UserData user;
  @override
  @JsonKey()
  final int createdAt;

  /// Create a copy of MoodData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MoodDataCopyWith<_MoodData> get copyWith =>
      __$MoodDataCopyWithImpl<_MoodData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MoodDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MoodData &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mood, content,
      const DeepCollectionEquality().hash(_imageUrls), user, createdAt);

  @override
  String toString() {
    return 'MoodData(mood: $mood, content: $content, imageUrls: $imageUrls, user: $user, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$MoodDataCopyWith<$Res>
    implements $MoodDataCopyWith<$Res> {
  factory _$MoodDataCopyWith(_MoodData value, $Res Function(_MoodData) _then) =
      __$MoodDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String mood,
      String content,
      List<String> imageUrls,
      UserData user,
      int createdAt});

  @override
  $UserDataCopyWith<$Res> get user;
}

/// @nodoc
class __$MoodDataCopyWithImpl<$Res> implements _$MoodDataCopyWith<$Res> {
  __$MoodDataCopyWithImpl(this._self, this._then);

  final _MoodData _self;
  final $Res Function(_MoodData) _then;

  /// Create a copy of MoodData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mood = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? user = null,
    Object? createdAt = null,
  }) {
    return _then(_MoodData(
      mood: null == mood
          ? _self.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of MoodData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get user {
    return $UserDataCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
