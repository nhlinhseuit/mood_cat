import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mood_cat/core/data/models/user_data.dart';

part 'mood_data.freezed.dart';
part 'mood_data.g.dart';

// Model MoodData
@freezed
abstract class MoodData with _$MoodData {
  const MoodData._();

  const factory MoodData({
    @Default('') String mood,
    @Default('') String content,
    @Default([]) List<String> imageUrls,
    @Default(UserData()) UserData user,
    @Default(0) int createdAt,
  }) = _MoodData;

  factory MoodData.fromJson(Map<String, dynamic> json) =>
      _$MoodDataFromJson(json);
}
