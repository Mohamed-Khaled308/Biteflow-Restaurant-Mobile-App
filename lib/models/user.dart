abstract class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String nationality;
  final DateTime birthDate;

  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.nationality,
      required this.birthDate});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
