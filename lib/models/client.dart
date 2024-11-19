import 'user.dart';

class Client extends User {
  
  const Client({required super.id, required super.name, required super.email});

  Client.fromData(Map<String, dynamic> data)
      : super(id: data['id'], name: data['name'], email: data['email']);
}
