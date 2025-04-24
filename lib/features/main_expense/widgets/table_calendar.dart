// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_cat/core/bloc/base_page_state.dart';
import 'package:mood_cat/core/widget/error.dart';
import 'package:mood_cat/core/widget/loading.dart';
import 'package:mood_cat/features/mood_content/data/models/mood_by_day/mood_by_day.dart';
import 'package:mood_cat/features/mood_content/presentation/bloc/mood_content_bloc.dart';
import 'package:mood_cat/features/mood_content/presentation/views/mood_content_bottom_sheet.dart';
import 'package:mood_cat/features/home_expense/widget/mood_select_bottom_sheet.dart';
import 'package:mood_cat/utils/app_utils.dart';
import 'package:mood_cat/utils/mood_util.dart';
import 'package:mood_cat/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  State<TableEventsExample> createState() => _TableEventsExampleState();
}

class _TableEventsExampleState
    extends BasePageState<TableEventsExample, MoodContentBloc> {
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

    bloc.add(const FetchMoodListEvent());
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

  void _onMoodDaySelected(
      DateTime selectedDay, DateTime focusedDay, MoodByDay mood) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null; // Important to clean those
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    var newMoodDocument = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Toàn màn hình
      builder: (BuildContext context) {
        return MoodContentBottomSheet(
          selectedDay: selectedDay,
          mood: mood.mood,
          dayContent: mood.content,
          dayImageUrls: mood.imageUrls,
        );
      },
    );

    if (newMoodDocument != null) {
      bloc.add(const FetchMoodListEvent());
    }
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
    ).then((mood) async {
      // Nếu nhận được mood, hiển thị ModalBottomSheet mới
      if (mood != null) {
        var newMoodDocument = await showModalBottomSheet(
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

        if (newMoodDocument != null) {
          bloc.add(const FetchMoodListEvent());
        }
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

  Widget getWidget(MoodContentState state) {
    if (state is MoodContentLoading) {
      return const Center(child: LoadingWidget());
    } else if (state is MoodContentError) {
      return Center(
          child: MyErrorWidget(
        onRetry: () {},
        message: state.message,
      ));
    } else if (state is MoodContentListLoaded) {
      return Column(
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
              markerDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
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
                return AppUtils.formatDateToVietnamese(date);
              },
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final int weekdayIndex = (day.weekday - DateTime.monday) % 7;
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
                return _buildDayCell(
                  day,
                  isSelected: false,
                  isToday: false,
                  moodListByDate: state.moodListByDay,
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  day,
                  isSelected: true,
                  isToday: false,
                  moodListByDate: state.moodListByDay,
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  day,
                  isSelected: false,
                  isToday: true,
                  moodListByDate: state.moodListByDay,
                );
              },
              outsideBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  day,
                  isSelected: false,
                  isToday: false,
                  isOutside: true,
                  moodListByDate: state.moodListByDay,
                );
              },
              markerBuilder: (context, day, events) {
                return null; // Không hiển thị bất kỳ marker nào
              },
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF202A35),
        body: BlocBuilder<MoodContentBloc, MoodContentState>(
          builder: (context, state) {
            return getWidget(state);
          },
        ),
      ),
    );
  }

  Widget _buildMoodDay(
    DateTime day,
    bool isToday,
    MoodByDay mood,
  ) {
    const double emojiSize = 48.0; // Kích thước mỗi emoji

    return GestureDetector(
      onTap: () {
        _onMoodDaySelected(day, day, mood);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: emojiSize,
            height: emojiSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mood.mood.color,
            ),
            child: Center(
              child: Text(
                mood.mood.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          Text(
            '${day.day}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day, {
    required bool isSelected,
    required bool isToday,
    required List<MoodByDay> moodListByDate,
    bool isOutside = false,
  }) {
    final DateTime currentDate = DateTime.now();
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final moodForDay = moodListByDate.firstWhere(
      (moodByDay) => isSameDay(moodByDay.date, normalizedDay),
      orElse: () => MoodByDay(
        mood: Mood.none, // Giá trị mặc định cho mood
        date: normalizedDay, // Dùng normalizedDay làm mặc định
        content: '', // Dùng normalizedDay làm mặc định
        imageUrls: [], // Dùng normalizedDay làm mặc định
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      width: 48,
      child: moodForDay.mood != Mood.none
          ? _buildMoodDay(
              day,
              isToday,
              moodForDay,
            )
          : isBeforeOrEqualCurrentDate(currentDate, day)
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
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
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
                            color: const Color(0xFF465D71),
                            width: 1.0,
                          ),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isToday ? const Color(0xFF202A35) : Colors.white,
                        fontSize: 12,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
    );
  }
}
