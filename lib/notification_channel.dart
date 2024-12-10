// import 'dart:io';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<void> createNotificationChannel() async {
//   if (Platform.isAndroid) {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'default_channel', // Channel ID
//       'Default Notifications', // Channel name
//       description: 'This is the default notification channel',
//       importance: Importance.high,
//       enableVibration: true,
//       playSound: true,
//     );

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
// }
