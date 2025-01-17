import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/services/payment_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/core/utils/price_calculator.dart';


class PaymentViewModel extends BaseModel {
  final PaymentService _paymentService = getIt<PaymentService>();
  final Set<String> _busyOrders = {};

  bool isBusy(String orderId) => _busyOrders.contains(orderId);

  void setBusyForOrder(String orderId, bool isBusy) {
    if (isBusy) {
      _busyOrders.add(orderId);
    } else {
      _busyOrders.remove(orderId);
    }
    notifyListeners();
  }


  Future<void> initiatePayment(double amount) async { // creates payment intent and payment sheet
    setBusy(true);

    int amountInCents = PriceCalculator.calculateAmountInCents(amount);
    Result<String> result = await _paymentService.createPaymentIntent(amountInCents);

    if (result.isSuccess) {
      String paymentIntentClientSecret = result.data!;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Biteflow',
          // preferredNetworks: [CardBrand.Visa, CardBrand.Mastercard],
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: ThemeConstants.primaryColor,
            ),
          )
        ),
      );
    }
    else{
    }
  }
}
