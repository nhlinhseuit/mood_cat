import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_cat/notification_service.dart';
import 'package:mood_cat/features/base/bloc/bloc/theme_bloc.dart';
import 'package:mood_cat/features/home_expense/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: const Color(0xFF202A35),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: MaterialApp(
          navigatorKey: navigatorKey, // Gán navigatorKey
          debugShowCheckedModeBanner: false,
          title: "My Application",
          themeMode: context.watch<ThemeBloc>().state.themeMode,
          home: const HomeScreenExpense(), // ✅ Điều hướng theo trạng thái login
        ));
  }
}
