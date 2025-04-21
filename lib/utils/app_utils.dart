import 'package:flutter/material.dart';

class AppUtils {
  static DateTime? _lastPressedAt;

  /// Hàm xử lý nhấn back 2 lần để thoát app
  static Future<bool> onWillPop(BuildContext context) async {
    final now = DateTime.now();
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nhấn back lần nữa để thoát",
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Colors.black.withOpacity(0.8),
          duration: const Duration(seconds: 2),
        ),
      );
      return false; // Không thoát
    }
    return true; // Thoát app
  }

  /// Hàm hiển thị snackbar với nội dung tùy chỉnh
  static void showSnackbar(BuildContext context, String message,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
