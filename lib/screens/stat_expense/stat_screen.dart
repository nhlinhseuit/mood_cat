import 'package:flutter/material.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF202A35),
      child: const Center(
        child: Row(
          children: [
            Text(
              'Yêu em bé của anh',
              style: TextStyle(
                color: Colors.white, // Màu chữ của tiêu đề (tháng, năm)
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Icon(Icons.heart),
          ],
        ),
      ),
    );
  }
}
