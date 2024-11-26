import 'package:biteflow/viewmodels/restaurant_onboarding_view_model.dart';
import 'package:biteflow/views/screens/restaurant_onboarding/restaurant_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class RestaurantOnboardingView extends StatelessWidget {
  const RestaurantOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<RestaurantOnboardingViewModel>(),
      child: RestaurantOnboardingScreen(),
    );
  }
}
