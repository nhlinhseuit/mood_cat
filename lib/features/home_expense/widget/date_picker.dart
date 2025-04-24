import 'package:flutter/material.dart';
import 'package:mood_cat/utils/app_utils.dart';
import 'package:mood_cat/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const DatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
    _selectedDay = widget.initialDate;
  }

  String formatMonthYearToVietnamese(DateTime dateTime) {
    int month = dateTime.month;
    int year = dateTime.year;
    return "Tháng $month năm $year";
  }

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color(0xFF202A35),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
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
              height: 8,
            ),

            // Tiêu đề ngày được chọn
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chọn ngày',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AppUtils.formatDate(_selectedDay),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            // Lịch
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: SizedBox(
                height: 350, // Giới hạn chiều cao của TableCalendar
                child: TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (selectedDay, focusedDay) {
                    // Chỉ cho phép chọn nếu ngày không nằm trước ngày hiện tại
                    if (isBeforeOrEqualCurrentDate(currentDate, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                    titleTextFormatter: (date, locale) {
                      return formatMonthYearToVietnamese(date);
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(color: Colors.white),
                    todayTextStyle: TextStyle(color: Colors.white),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    outsideTextStyle: TextStyle(color: Colors.grey),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal, // Màu nền ngày được chọn
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final int weekdayIndex =
                          (day.weekday - DateTime.monday) % 7;
                      return Center(
                        child: Text(
                          vietnameseWeekdays[weekdayIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      if (!isBeforeOrEqualCurrentDate(currentDate, day)) {
                        return Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      // Nếu không, giữ style mặc định
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      if (!isBeforeOrEqualCurrentDate(currentDate, day)) {
                        return Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.teal,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 1.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      // Ngày ngoài tháng hiện tại
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Nút Hủy và OK
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng date picker
                  },
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Color.fromARGB(255, 110, 92, 92)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onDateSelected(
                        _selectedDay); // Gọi callback để cập nhật ngày
                    Navigator.pop(context, _selectedDay); // Đóng date picker
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height:
                    16.0), // Thêm khoảng cách dưới cùng để tránh cắt nội dung
          ],
        ),
      ),
    );
  }
}
