import 'package:biteflow/models/user.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(User user) async {
    // Request permission to show notifications

    print("USERTOKEN: ${user.fcmToken}");
    print("USERID: ${user.id}");
    print("USERRole: ${user.role}");
    if (user.fcmToken == '') {
      // Get the FCM token
      await _firebaseMessaging.requestPermission();
      String? token = await _firebaseMessaging.getToken();
      print("Token: $token");
      // FirebaseMessaging.onBackgroundMessage(My_fm_BackgroundHandler);

      if (token != null) {
        // Update the FCM token in the user's Firestore document
        final updatedUser = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          fcmToken: token,
        );

        final result = await UserService().updateUser(updatedUser);

        if (result.data ?? false) {
          print("User updated successfully");
        } else {
          print("Error updating user: ${result.error}");
        }
      }
    }
  }

  Future handleBackgroundNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Handling a background message: ${message.messageId}");
      }
    });
  }
}

  

  // void setUpFirebase() {
  //   // Request permission for iOS
  //   messaging.requestPermission();

  //   // Listen for foreground messages
  //   FirebaseMessaging.onMessage.listen((message) {
  //     print("Foreground message received: ${message.data}");
  //     if (message.notification != null) {
  //       // Optional: Display local notification using FlutterLocalNotificationsPlugin
  //       print("Notification Title: ${message.notification!.title}");
  //       print("Notification Body: ${message.notification!.body}");
  //     }
  //   });
  // }

