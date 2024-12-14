import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  // Function to trigger the callable function for split request notifications
  Future<void> sendSplitRequestNotification(
      List<String> userIds, String title, String message, String itemId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendSplitRequestNotification');
      await callable.call({
        'userIds': userIds, // List of user IDs to send notification to
        'title': title, // Title of the notification
        'message': message, // Message of the notification
        'itemId': itemId,
      });

      // Handle the result
      // if (result.data['success']) {
      //   print('Split request notification sent successfully');
      // } else {
      //   print(
      //       'Failed to send split request notification: ${result.data['message']}');
      // }
    } catch (e) {
      // print('Error calling the Firebase function: $e');
    }
  }
}
