class OrderClientsPayment {
  final String userId;
  bool isPaid;
  double amount;

  OrderClientsPayment({
    required this.userId,
    required this.isPaid,
    required this.amount,
  });

  OrderClientsPayment.fromData(Map<String, dynamic> data)
      : userId = data['userId'],
        isPaid = data['isPaid'],
        amount = data['amount'];
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isPaid': isPaid,
      'amount': amount,
    };
  }
}