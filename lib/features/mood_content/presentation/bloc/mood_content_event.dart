part of 'mood_content_bloc.dart';

sealed class MoodContentEvent extends Equatable {
  const MoodContentEvent();

  @override
  List<Object> get props => [];
}

// truyền mooddata theo savemoodevent

class SaveMoodEvent extends MoodContentEvent {
  final DateTime selectedDay;
  final Mood mood;
  final String content;
  final List<File> images;
  final List<String> existingImageUrls;

  const SaveMoodEvent({
    required this.selectedDay,
    required this.mood,
    required this.content,
    required this.images,
    required this.existingImageUrls,
  });
}

class FetchMoodListEvent extends MoodContentEvent {
  const FetchMoodListEvent();

  @override
  List<Object> get props => [];
}
