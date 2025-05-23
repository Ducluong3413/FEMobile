// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationHelper {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Khởi tạo notification
//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidInitSettings,
//     );

//     await _notificationsPlugin.initialize(initSettings);

//     // Tạo notification channel (không có bypass DnD)
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // ID
//       'High Importance Notifications', // Tên
//       description: 'This channel is used for important notifications',
//       importance: Importance.max,
//     );

//     final androidPlugin =
//         _notificationsPlugin
//             .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin
//             >();

//     await androidPlugin?.createNotificationChannel(channel);
//   }

//   // Hiển thị thông báo
//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           channelDescription:
//               'This channel is used for important notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _notificationsPlugin.show(
//       0, // ID
//       title,
//       body,
//       notificationDetails,
//     );
//   }

//   // Hàm kiểm tra và yêu cầu quyền DnD nếu API có hỗ trợ
//   static Future<void> requestDnDAccessIfAvailable() async {
//     // DnD access methods are not available in the current plugin version.
//     // You may need to implement this functionality using platform channels.
//     print("⚠️ DnD access methods are not supported in this version.");
//   }
// }
