// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mood_cat/screens/home_expense/widget/mood_content_bottom_sheet.dart';
import 'package:mood_cat/screens/home_expense/widget/mood_select_bottom_sheet.dart';
import 'package:mood_cat/utils/app_utils.dart';
import 'package:mood_cat/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  State<TableEventsExample> createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isBeforeCurrentDate(DateTime.now(), selectedDay)) {
      return;
    }

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null; // Important to clean those
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Để nền trong suốt
      builder: (BuildContext context) {
        return MoodSelectionBottomSheet(selectedDay: selectedDay);
      },
    ).then((mood) {
      // Nếu nhận được mood, hiển thị ModalBottomSheet mới
      if (mood != null) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true, // Toàn màn hình
          builder: (BuildContext context) {
            return MoodContentBottomSheet(
              selectedDay: selectedDay,
              mood: mood,
            );
          },
        );
      }
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF202A35),
        body: Column(
          children: [
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              rowHeight: 80,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: TextStyle(color: Colors.black),
                todayTextStyle: TextStyle(color: Colors.black),
                selectedTextStyle: TextStyle(color: Colors.black),
                weekendTextStyle: TextStyle(color: Colors.black),
                outsideTextStyle: TextStyle(color: Colors.grey),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible:
                    false, // Ẩn nút thay đổi format (vì đã cố định format)
                titleCentered: true, // Căn giữa tiêu đề
                titleTextStyle: const TextStyle(
                  color: Colors.white, // Màu chữ của tiêu đề (tháng, năm)
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white, // Màu của nút điều hướng bên trái
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white, // Màu của nút điều hướng bên phải
                ),
                titleTextFormatter: (date, locale) {
                  return AppUtils.formatDateToVietnamese(date);
                },
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  // `day` là ngày đại diện cho cột thứ (từ thứ Hai đến Chủ Nhật)
                  final int weekdayIndex = (day.weekday - DateTime.monday) %
                      7; // Tính chỉ số thứ (0-6)
                  return Center(
                    child: Text(
                      vietnameseWeekdays[
                          weekdayIndex], // Lấy nhãn thứ từ danh sách
                      style: const TextStyle(
                        color: Colors.white, // Màu chữ của nhãn thứ
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: false, isToday: false);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: true, isToday: false);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: false, isToday: true);
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day,
                      isSelected: false, isToday: false, isOutside: true);
                },
                markerBuilder: (context, day, events) {
                  // Hiển thị mũi tên cho ngày được chọn
                  if (isSameDay(day, _selectedDay)) {
                    return Positioned(
                      bottom: -14,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 28.0,
                        color: Colors.green.shade400,
                      ),
                    );
                  }
                  // Hiển thị dấu chấm cho sự kiện (nếu có)
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: -4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          events.length > 3 ? 3 : events.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.0),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .green.shade400, // Màu xanh lá pastel đậm hơn
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day,
      {required bool isSelected,
      required bool isToday,
      bool isOutside = false}) {
    final DateTime currentDate = DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      width: 48,
      // color: Colors.yellow,
      child: isBeforeOrEqualCurrentDate(currentDate, day)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF465D71),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2.0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF586D7F),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2.0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 17.0,
                        color: Color(0xFF7F909C),
                        weight: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isOutside ? Colors.green.shade400 : Colors.white,
                    fontSize: 10,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            )
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.green.shade400
                    : isToday
                        ? const Color(0xFFCDD4D9)
                        : Colors.transparent,
                border: isToday
                    ? null
                    : Border.all(
                        color: const Color(
                            0xFF465D71), // Thêm border màu 0xFF465D71
                        width: 1.0, // Độ dày của border, bạn có thể điều chỉnh
                      ),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isToday ? const Color(0xFF202A35) : Colors.white,
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
    );
  }
}
