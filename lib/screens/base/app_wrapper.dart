import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_cat/screens/base/bloc/bloc/theme_bloc.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(const LoadTheme())),
        // BlocProvider(
        //     create: (_) => GetExpensesBloc(FirebaseExpenseRepo())
        //       ..add(GetExpenses())),
      ],
      child: child,
    );
  }
}
