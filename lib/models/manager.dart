import 'user.dart';

class Manager extends User {
  final String restaurantId;

  const Manager({
    required this.restaurantId,
    required super.id,
    required super.name,
    required super.email,
  }) : super(role: 'Manager');

  Manager.fromData(Map<String, dynamic> data)
      : restaurantId = data['restaurantId'],
        super(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          role: 'Manager',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      ...super.toJson(),
    };
  }
}
