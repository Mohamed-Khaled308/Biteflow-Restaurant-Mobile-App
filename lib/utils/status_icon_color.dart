import 'package:flutter/material.dart';
import 'package:biteflow/constants/business_constants.dart';

class StatusIconColor {
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case BusinessConstants.pendingStatus:
        return Icons.hourglass_empty;
      case BusinessConstants.inprogressStatus:
        return Icons.sync;
      case BusinessConstants.acceptedStatus:
        return Icons.check_circle;
      case BusinessConstants.servedStatus:
        return Icons.restaurant;
      default:
        return Icons.error;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case BusinessConstants.pendingStatus:
        return Colors.orange;
      case BusinessConstants.inprogressStatus:
        return Colors.blue;
      case BusinessConstants.acceptedStatus:
        return Colors.green;
      case BusinessConstants.servedStatus:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

 
}