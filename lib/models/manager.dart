import 'user.dart';

class Manager extends User {
  final String restaurantId;
  final String restaurantName;

  const Manager(
      {required this.restaurantId,
      required this.restaurantName,
      required super.id,
      required super.name,
      required super.email});

  Manager.fromData(Map<String, dynamic> data)
      : restaurantId = data['restaurantId'],
        restaurantName = data['restaurantName'],
        super(id: data['id'], name: data['name'], email: data['email']);

  @override
  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      ...super.toJson(),
    };
  }
}
