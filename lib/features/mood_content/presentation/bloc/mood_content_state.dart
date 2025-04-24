part of 'mood_content_bloc.dart';

sealed class MoodContentState extends Equatable {
  const MoodContentState();

  @override
  List<Object> get props => [];
}

final class MoodContentInitial extends MoodContentState {}

class MoodContentLoading extends MoodContentState {}

class MoodContentSaved extends MoodContentState {
  final String documentId;

  const MoodContentSaved(this.documentId);
}

class MoodContentError extends MoodContentState {
  final String message;

  const MoodContentError(this.message);
}

class MoodContentListLoaded extends MoodContentState {
  final List<MoodByDay> moodListByDay;

  const MoodContentListLoaded(this.moodListByDay);

  @override
  List<Object> get props => [moodListByDay];
}
