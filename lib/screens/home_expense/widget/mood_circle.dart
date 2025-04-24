import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mood_cat/utils/mood_util.dart';

class MoodCircle extends StatelessWidget {
  const MoodCircle({super.key});

  @override
  Widget build(BuildContext context) {
    const double circleRadius = 120.0; // Bán kính vòng tròn
    const double emojiSize = 50.0; // Kích thước mỗi emoji

    const List<Mood> moods = Mood.values; // Lấy tất cả các giá trị của Mood

    return SizedBox(
      width: circleRadius * 2,
      height: circleRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(moods.length, (index) {
          final Mood mood = moods[index];
          // Tính góc cho mỗi emoji (chia đều trên vòng tròn)
          final double angle = (2 * 3.14159 / moods.length) * index;
          return Positioned(
            left: circleRadius +
                circleRadius * 0.8 * (cos(angle)) -
                (emojiSize / 2),
            top: circleRadius +
                circleRadius * 0.8 * (sin(angle)) -
                (emojiSize / 2),
            child: GestureDetector(
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
          );
        }),
      ),
    );
  }
}
