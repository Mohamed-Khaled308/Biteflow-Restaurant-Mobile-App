import 'user.dart';

class Client extends User {
  final List<String> orderIds;
  const Client(
      {required this.orderIds,
      required super.id,
      required super.name,
      required super.email,
      required super.nationality,
      required super.birthDate})
      : super(role: 'client');

  Client.fromData(Map<String, dynamic> data)
      : orderIds = data['orderIds'],
        super(
            id: data['id'],
            name: data['name'],
            email: data['email'],
            role: data['role'],
            nationality: data['nationality'],
            birthDate: data['birthDate']);
}
