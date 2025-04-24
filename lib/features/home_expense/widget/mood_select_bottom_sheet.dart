import 'package:flutter/material.dart';
import 'package:mood_cat/features/home_expense/widget/date_picker.dart';
import 'package:mood_cat/features/home_expense/widget/mood_circle.dart';
import 'package:mood_cat/utils/app_utils.dart';

class MoodSelectionBottomSheet extends StatefulWidget {
  final DateTime selectedDay;

  const MoodSelectionBottomSheet({super.key, required this.selectedDay});

  @override
  State<MoodSelectionBottomSheet> createState() =>
      _MoodSelectionBottomSheetState();
}

class _MoodSelectionBottomSheetState extends State<MoodSelectionBottomSheet> {
  late DateTime _currentSelectedDay;

  @override
  void initState() {
    super.initState();
    _currentSelectedDay = widget.selectedDay;
  }

  void _showDatePicker(BuildContext context) async {
    var selectedDate = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Cho phép ModalBottomSheet chiếm toàn màn hình
      builder: (BuildContext context) {
        return DatePickerBottomSheet(
          initialDate: _currentSelectedDay,
          onDateSelected: (DateTime newDate) {
            setState(() {
              _currentSelectedDay = newDate;
            });
          },
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _currentSelectedDay = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF202A35), // Màu nền giống lịch
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // thanh
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          // Tiêu đề
          const Text(
            'Em bé đang cảm thấy thế nào?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          // Ngày
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Ngày ${AppUtils.formatDateToVietnamese(_currentSelectedDay)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36.0),
          const MoodCircle(),
          const SizedBox(height: 48.0),
        ],
      ),
    );
  }
}
