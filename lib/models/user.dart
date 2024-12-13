abstract class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String fcmToken;
  final int unseenOfferCount;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.fcmToken = '',
    this.unseenOfferCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'fcmToken': fcmToken,
      'unseenOfferCount': unseenOfferCount,
    };
  }
}

// class UserModel extends User {

//   const UserModel({
//     required super.id,
//     required super.name,
//     required super.email,
//     required super.role,
//     super.fcmToken,
//     super.unseenOfferCount = 0,
//   });
// }
