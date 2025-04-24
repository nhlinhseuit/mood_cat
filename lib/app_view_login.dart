import 'package:flutter/material.dart';
import 'package:mood_cat/features/login/views/login_page.dart';

class MyAppViewLogin extends StatelessWidget {
  const MyAppViewLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Application",
      home: LoginPage(), // ✅ Điều hướng theo trạng thái login
    );
  }
}
