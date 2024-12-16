import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/user.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotifications with WidgetsBindingObserver {
  static final FirebaseNotifications _instance =
      FirebaseNotifications._internal();

  factory FirebaseNotifications() => _instance;

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _isListenerSetUp = false; // Flag to check if the listener is set

  String? _notificationTitle;
  String? _notificationBody;
  String? _notificationData;

  FirebaseNotifications._internal();

  Future<void> initNotifications(User user) async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();

    if (user.fcmToken == '' || user.fcmToken != token) {
      if (token != null) {
        final updatedUser = Client(
          id: user.id,
          name: user.name,
          email: user.email,
          fcmToken: token,
          orderIds: (user as Client).orderIds,
          unseenOfferCount: user.unseenOfferCount,
        );
        await UserService().updateUser(updatedUser);
      }
    }

    // Set up notification handlers only once
    if (!_isListenerSetUp) {
      setupNotificationHandlers();
      _isListenerSetUp = true;
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data['type'] == 'split_request') {
        // Save the notification details to show when the app is fully initialized
        _notificationTitle = message.notification?.title;
        _notificationBody = message.notification?.body;
      }
    });
  }

  void setupNotificationHandlers() {
    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundNotification(message);
    });

    // Handle when a notification is tapped while the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundNotification(message);
    });
  }

  void _handleForegroundNotification(RemoteMessage message) {
    final notificationType = message.data['type']; // 'offer' or 'split_request'
    if (notificationType == 'offer') {
      _showOfferNotification(
          message.notification?.title, message.notification?.body);
    } else if (notificationType == 'split_request') {
      _notificationData = message.data['itemId'];
      _showSplitRequestNotification(
          message.notification?.title, message.notification?.body);
    }
  }

  void _handleBackgroundNotification(RemoteMessage message) {
    if (message.data['type'] == 'split_request') {
      // Save the notification details to be shown when the app is resumed
      _notificationTitle = message.notification?.title;
      _notificationBody = message.notification?.body;
      _notificationData = message.data['itemId'];

      // print('Saved notification opened!');
      _showSplitRequestNotification(_notificationTitle, _notificationBody);
    }
  }

  void _showOfferNotification(String? title, String? body) {
    if (title != null && body != null) {
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: ThemeConstants.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _showSplitRequestNotification(String? title, String? body) {
    if (title != null && body != null) {
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: ThemeConstants.blackColor20,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getIt<CartViewModel>()
                          .acceptInvitation(_notificationData!);
                      messengerKey.currentState?.hideCurrentSnackBar();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getIt<CartViewModel>()
                          .cancelInvitation(_notificationData!);
                      messengerKey.currentState?.hideCurrentSnackBar();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Reject'),
                  ),
                ],
              ),
            ],
          ),
          duration: const Duration(days: 1), // Duration for indefinite display
        ),
      );
    }
  }

  // App lifecycle observer methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check if there is a saved notification to show when the app is resumed
      if (_notificationTitle != null && _notificationBody != null) {
        // Use a slight delay to ensure the app is fully initialized
        Future.delayed(const Duration(milliseconds: 3000), () {
          // print('Showing saved notification');
          _showSplitRequestNotification(_notificationTitle, _notificationBody);
          // Reset saved notification
          _notificationTitle = null;
          _notificationBody = null;
        });
      }
    }
  }
}
