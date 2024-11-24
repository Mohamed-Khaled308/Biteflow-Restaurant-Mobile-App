import 'package:biteflow/viewmodels/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';
import 'signup_screen.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SignupViewModel>(),
      child: const SignupScreen(),
    );
  }
}
