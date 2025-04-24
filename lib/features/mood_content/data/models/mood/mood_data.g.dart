// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoodData _$MoodDataFromJson(Map<String, dynamic> json) => _MoodData(
      mood: json['mood'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      user: json['user'] == null
          ? const UserData()
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MoodDataToJson(_MoodData instance) => <String, dynamic>{
      'mood': instance.mood,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'user': instance.user.toJson(),
      'createdAt': instance.createdAt,
    };
