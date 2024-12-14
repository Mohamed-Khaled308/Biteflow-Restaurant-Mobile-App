import 'package:biteflow/models/order_full_clients_payment.dart';

class PriceCalculator {
  static int calculateAmountInCents(double amount) {
    return (amount * 100).toInt();
  }

  static double getPaidAmount(List<OrderFullClientsPayment>? orderFullClientsPayments) {
    if(orderFullClientsPayments == null) return 0;
    double paidAmount = 0;
    for(OrderFullClientsPayment orderFullClientsPayment in orderFullClientsPayments){
      if(orderFullClientsPayment.isPaid){
        paidAmount += orderFullClientsPayment.amount;
      }
    }
    return paidAmount;
  }
}