import 'user.dart';

class Client extends User {
  final List<String> orderIds;

  Client({
    required super.id,
    required super.name,
    required super.email,
    super.fcmToken,
    this.orderIds = const [],
  }) : super(role: 'Client');

  factory Client.fromData(Map<String, dynamic> data) {
    return Client(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      fcmToken: data['fcmToken'],
      orderIds: (data['orderIds'] != null && data['orderIds'] is List)
          ? List<String>.from(data['orderIds'] as List)
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'orderIds': orderIds,
      ...super.toJson(),
    };
  }

  @override
  String toString() {
    return 'Client{id: $id, name: $name, email: $email, fcmToken: $fcmToken, orderIds: $orderIds}';
  }
}
