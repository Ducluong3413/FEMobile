import 'package:assistantstroke/firebase_options.dart';
import 'package:assistantstroke/helper/notification_helper.dart';
import 'package:assistantstroke/providers/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:assistantstroke/page/my_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await NotificationHelper.init(); // << THÊM DÒNG NÀY
  // await NotificationHelper.requestDnDAccessIfAvailable(); // << THÊM DÒNG NÀY

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // // Đợi token APNs được set (chỉ trên iOS)
  // String? apnsToken = await messaging.getAPNSToken();
  // if (apnsToken != null) {
  //   await messaging.subscribeToTopic('stroke-ai-app');
  // }
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseMessaging.instance.subscribeToTopic('stroke-ai-app');
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('FCM Token: $fcmToken');
  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // Thêm các provider khác nếu có
      ],
      child: const MyApp(),
    ),
  );
}

// import 'package:assistantstroke/firebase_options.dart';
// import 'package:assistantstroke/page/my_app.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('📩 Background message received: ${message.messageId}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Tạo notification channel cho Android
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // ID phải giống trong AndroidManifest.xml
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin
//       >()
//       ?.createNotificationChannel(channel);

//   // Đăng ký handler background
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // Đăng ký topic
//   await FirebaseMessaging.instance.subscribeToTopic('stroke-ai-app');

//   final fcmToken = await FirebaseMessaging.instance.getToken();
//   print('FCM Token: $fcmToken');

//   runApp(const MyApp());
// }

// import 'package:assistantstroke/firebase_options.dart';
// import 'package:assistantstroke/page/my_app.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('🔙 Handling a background message: ${message.messageId}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   await FirebaseMessaging.instance.subscribeToTopic('stroke-ai-app');
//   final fcmToken = await FirebaseMessaging.instance.getToken();
//   print('FCM Token: $fcmToken');

//   runApp(const MyApp());
// }

// import 'package:assistantstroke/firebase_options.dart';
// import 'package:assistantstroke/page/my_app.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Logic xử lý thông báo
//   print('🔙 Handling a background message: ${message.messageId}');
//   print('Background message data: ${message.data}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Yêu cầu quyền thông báo cho iOS
//   NotificationSettings settings = await FirebaseMessaging.instance
//       .requestPermission(alert: true, badge: true, sound: true);

//   print('User granted permission: ${settings.authorizationStatus}');
//   await Future.delayed(Duration(seconds: 1));
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   await FirebaseMessaging.instance.subscribeToTopic('stroke-ai-app');
//   final fcmToken = await FirebaseMessaging.instance.getToken();
//   print('FCM Token: $fcmToken');

//   runApp(const MyApp());
// }
