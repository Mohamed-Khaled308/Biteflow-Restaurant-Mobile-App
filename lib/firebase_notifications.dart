import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/user.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class FirebaseNotifications {
  static final FirebaseNotifications _instance =
      FirebaseNotifications._internal();

  factory FirebaseNotifications() => _instance;

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseNotifications._internal();

  Future<void> initNotifications(User user) async {
    // print("USERTOKEN: ${user.fcmToken}");

    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();

    // print("GeneratedTOKEN: $token");

    if (user.fcmToken == '' || user.fcmToken != token) {
      // print("Token Update: $token");

      if (token != null) {
        final updatedUser = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          fcmToken: token,
        );

        await UserService().updateUser(updatedUser);

        // if (result.data ?? false) {
        //   print("User updated successfully");
        // } else {
        //   print("Error updating user: ${result.error}");
        // }
      }
    }

    // Set up handlers for notifications
    setupNotificationHandlers();
  }

  void setupNotificationHandlers() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print("Foreground Notification: ${message.notification?.title}");
      _showForegroundNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });

    // Background
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // if (message != null) {
      //   print(
      //       'Notification while app was terminated: ${message.notification?.title}');
      // }
    });
  }

  Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    // print('Handling background message: ${message.messageId}');
  }

  void _showForegroundNotification({String? title, String? body}) {
    if (title != null && body != null) {
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: ThemeConstants.successColor, // Use primary color
          behavior:
              SnackBarBehavior.floating, // Floating style for better appearance
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          margin: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 10), // Add some margins
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white, // Text color for the title
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  color:
                      Colors.white70, // Slightly muted text color for the body
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
