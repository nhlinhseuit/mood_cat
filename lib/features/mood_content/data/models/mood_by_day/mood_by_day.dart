import 'package:mood_cat/utils/mood_util.dart';

class MoodByDay {
  final Mood mood;
  final DateTime date;
  final String content;
  final List<String> imageUrls;

  MoodByDay({
    required this.mood,
    required this.date,
    required this.content,
    required this.imageUrls,
  });
}
