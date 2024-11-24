import 'user.dart';

class Client extends User {
  final List<String> orderIds;

  Client({
    required super.id,
    required super.name,
    required super.email,
    this.orderIds = const [],
  }) : super(role: 'Client');

  factory Client.fromData(Map<String, dynamic> data) {
    return Client(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
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
}
