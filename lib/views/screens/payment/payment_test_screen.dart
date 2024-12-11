import 'package:biteflow/viewmodels/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:biteflow/core/constants/theme_constants.dart';



class PaymentTestScreen extends StatefulWidget {
    const PaymentTestScreen({super.key});

    @override
    State<PaymentTestScreen> createState() => _PaymentTestScreenState();
}

class _PaymentTestScreenState extends State<PaymentTestScreen> {

    final double amount = 10.0;

    @override
    Widget build(BuildContext context) {
      final viewModel = context.watch<PaymentViewModel>();

      return Scaffold(
          appBar: AppBar(
              title: const Text('Payment Test'),
          ),
          body: Center(
              child: ElevatedButton(
                  onPressed: () async{
                      await viewModel.initiatePayment(amount);
                      Stripe.instance.presentPaymentSheet().then((value){
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment Successful'),
                              backgroundColor: ThemeConstants.successColor,
                            ),
                          );
                        }
                        /***  here we can make the required updates to the UI and db ***/

                      }).catchError((e){
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment process was interrupted. Please try again.'),
                              backgroundColor: ThemeConstants.errorColor,
                            ),
                          );
                        }
                      });
                  },
                  child: const Text('Pay'),
              ),
          ),
      );
    }
}