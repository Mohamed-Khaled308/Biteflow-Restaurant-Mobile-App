import 'user.dart';

class Manager extends User {
  final String restaurantId;

  const Manager(
      {required this.restaurantId,
      required super.id,
      required super.name,
      required super.email,
      required super.nationality,
      required super.birthDate})
      : super(role: 'manager');

  Manager.fromData(Map<String, dynamic> data)
      : restaurantId = data['restaurantId'],
        super(
            id: data['id'],
            name: data['name'],
            email: data['email'],
            role: data['role'],
            nationality: data['nationality'],
            birthDate: data['birthDate']);

  @override
  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      ...super.toJson(),
    };
  }
}
