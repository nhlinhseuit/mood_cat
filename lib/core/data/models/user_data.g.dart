// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserData _$UserDataFromJson(Map<String, dynamic> json) => _UserData(
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(_UserData instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'photoURL': instance.photoURL,
    };
