import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/payment_view_model.dart';
import 'package:biteflow/views/screens/payment/payment_test_screen.dart';

class PaymentTestView extends StatelessWidget {
  const PaymentTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<PaymentViewModel>(),
      child: const PaymentTestScreen()
    );
  }
}