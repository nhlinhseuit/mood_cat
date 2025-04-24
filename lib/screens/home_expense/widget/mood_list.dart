import 'package:flutter/material.dart';
import 'package:mood_cat/utils/mood_util.dart';

class MoodList extends StatelessWidget {
  const MoodList({super.key});

  @override
  Widget build(BuildContext context) {
    const double emojiSize = 50.0; // Kích thước mỗi emoji
    const double spacing = 16.0; // Khoảng cách giữa các emoji

    const List<Mood> moods = Mood.values; // Lấy tất cả các giá trị của Mood

    return Wrap(
      spacing: spacing, // Khoảng cách ngang giữa các emoji
      runSpacing: spacing, // Khoảng cách dọc giữa các hàng
      alignment: WrapAlignment.center, // Căn giữa các phần tử
      children: List.generate(moods.length, (index) {
        final Mood mood = moods[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji
            GestureDetector(
              onTap: () {
                Navigator.pop(context, mood);
              },
              child: Container(
                width: emojiSize,
                height: emojiSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mood.color, // Lấy màu từ Mood
                ),
                child: Center(
                  child: Text(
                    mood.emoji, // Lấy emoji từ Mood
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0), // Khoảng cách giữa emoji và nhãn
            // Nhãn
            Text(
              mood.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        );
      }),
    );
  }
}
