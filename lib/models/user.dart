abstract class User {
  final String id;
  final String name;
  final String email;
  // nationality
  // birth date 

  const User({required this.id, required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
