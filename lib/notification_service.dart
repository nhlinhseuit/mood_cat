import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood_cat/features/home_expense/views/home_screen.dart';

//TODO1: Xử lý vì sao từ background push tới HomeExpense lỗi  - DONE
//TODO2: Truyền payload để có thể xử lý được navigate tới màn nào (OK - Backend gửi, nhận được xong lấy ra data từ json như bên izota)

// Khởi tạo plugin flutter_local_notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// GlobalKey để điều hướng
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Top-level function cho background notification
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print(
      'noti msg: onDidReceiveBackgroundNotificationResponse: ${response.payload}');

  handleNotificationAction(response.payload);
}

//? TH1: Xử lý click noti từ background hoặc terminated của FirebaseMessaging
//? TH2: Xử lý local notification (xài chung)
void handleNotificationAction(String? payload) {
  print('handleNotificationAction: $payload');
  WidgetsBinding.instance.addPostFrameCallback((_) {
    //? Kiểm tra xem navigatorKey đã sẵn sàng chưa

    const String green = '\x1B[32m';
    const String reset = '\x1B[0m';

    if (navigatorKey.currentState != null &&
        navigatorKey.currentState!.mounted) {
      print('$green navigatorKey.currentState != null $reset');

      // if (payload == 'home_expense') {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => const HomeScreenExpense(),
        ),
      );
      // }
    } else {
      print('Navigator not ready for payload: $payload');
    }
  });
}

class NotificationService {
  static Future<void> initialize() async {
    // Yêu cầu quyền thông báo
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Cấu hình flutter_local_notifications cho Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Icon của ứng dụng

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //? Lắng nghe khi nhấn vào thông báo FCM foreground (vì FCM sd này để show lên noti) + Hoặc nhấn vào thông báo foreground của local
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print('noti msg: onDidReceiveNotificationResponse');
        handleNotificationAction(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    //? Lắng nghe thông báo khi ứng dụng ở foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('noti msg: Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        _showNotification(message);
      }
    });

    //? Lắng nghe khi nhấn vào thông báo (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('noti msg: onMessageOpenedApp clicked: ${message.messageId}');
      handleNotificationAction(message.data['type']);
    });

    //? Xử lý thông báo khi ứng dụng khởi động từ trạng thái terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(
          'noti msg: getInitialMessage. App opened from terminated state: ${initialMessage.messageId}');
      // Điều hướng ngay khi ứng dụng khởi động
      Future.delayed(Duration.zero, () {
        handleNotificationAction(initialMessage.data['type']);
      });
    }
  }

  // Hàm hiển thị thông báo
  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'expense_tracker_channel', // Channel ID
      'Expense Tracker Notifications', // Channel Name
      channelDescription: 'Notifications for expense tracker app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID thông báo
      message.notification?.title ?? 'Expense Tracker',
      message.notification?.body ?? 'You have a new notification',
      platformChannelSpecifics,
    );
  }
}
