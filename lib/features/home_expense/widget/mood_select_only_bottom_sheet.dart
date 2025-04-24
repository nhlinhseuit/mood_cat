import 'package:flutter/material.dart';
import 'package:mood_cat/features/home_expense/widget/mood_list.dart';

class MoodSelectionOnlyBottomSheet extends StatefulWidget {
  const MoodSelectionOnlyBottomSheet({super.key});

  @override
  State<MoodSelectionOnlyBottomSheet> createState() =>
      _MoodSelectionBottomSheetState();
}

class _MoodSelectionBottomSheetState
    extends State<MoodSelectionOnlyBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF202A35),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề và nút đóng nằm ngang
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 48.0,
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Em bé cảm thấy thế nào?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          const MoodList(),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }
}
