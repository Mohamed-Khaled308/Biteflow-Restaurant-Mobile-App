class OrderItemParticipant {
  final String userId;
  final String userName;

  OrderItemParticipant({
    required this.userId,
    required this.userName,
  });

  OrderItemParticipant.fromData(Map<String, dynamic> data)
      : userId = data['userId'],
        userName = data['userName'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
    };
  }
        
}