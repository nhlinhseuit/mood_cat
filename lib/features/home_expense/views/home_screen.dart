import 'dart:math';

// import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_cat/features/base/bloc/bloc/theme_bloc.dart';
import 'package:mood_cat/features/main_expense/main_screen.dart';
import 'package:mood_cat/features/stat_expense/stat_screen.dart';
// import 'package:mood_cat/screens/home_expense/get_expenses_blocs/bloc/get_expenses_bloc.dart';
import 'package:mood_cat/utils/app_utils.dart';

class HomeScreenExpense extends StatefulWidget {
  const HomeScreenExpense({super.key});

  @override
  State<HomeScreenExpense> createState() => _HomeScreenExpenseState();
}

class _HomeScreenExpenseState extends State<HomeScreenExpense> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Color getSelectedItem() {
      return context.read<ThemeBloc>().state.themeMode == ThemeMode.light
          ? Colors.blue
          : Colors.blueAccent;
    }

    Color getUnSelectedItem() {
      return context.read<ThemeBloc>().state.themeMode == ThemeMode.light
          ? Colors.grey
          : Colors.black54;
    }

    // return BlocBuilder<GetExpensesBloc, GetExpensesState>(
    //   builder: (context, state) {
    //     if (state is GetExpensesSuccess) {
    return WillPopScope(
      onWillPop: () => AppUtils.onWillPop(context),
      child: Scaffold(
        body: index == 0 ? const MainScreen() : const StatScreen(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Đổ bóng nhẹ
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF324553),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0, // Xóa bóng mặc định để tránh xung đột
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                    color: index == 0 ? getSelectedItem() : getUnSelectedItem(),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.graph_square,
                    color: index == 1 ? getSelectedItem() : getUnSelectedItem(),
                  ),
                  label: 'Stats',
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          shape: const CircleBorder(),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal.shade400,
            ),
            child: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    // } else {
    //   return const Scaffold(
    //       body: Center(child: CircularProgressIndicator()));
    // }
    // },
    // );
  }
}
