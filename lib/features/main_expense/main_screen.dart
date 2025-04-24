import 'package:flutter/material.dart';
import 'package:mood_cat/features/main_expense/widgets/table_calendar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const TableEventsExample(),
    );
  }
}
