import 'package:biteflow/models/client.dart';

class OrderFullClientsPayment {
  final Client client;
  bool isPaid;
  double amount;

  OrderFullClientsPayment({
    required this.client,
    required this.isPaid,
    required this.amount,
  });

}