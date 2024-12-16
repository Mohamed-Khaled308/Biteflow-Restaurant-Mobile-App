import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/feedback_view_model.dart';
import 'package:biteflow/views/screens/feedback/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackView extends StatelessWidget {
  final String restaurantId;

  const FeedbackView({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<FeedbackViewModel>(),
      child: FeedbackScreen(restaurantId: restaurantId),
    );
  }
}