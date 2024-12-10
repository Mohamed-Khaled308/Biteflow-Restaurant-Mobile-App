abstract class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String fcmToken;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.fcmToken = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'fcmToken': fcmToken,
    };
  }
}

class UserModel extends User {

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.fcmToken,
  });
}
