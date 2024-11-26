class AuthHelper {
  static const String clientRole = 'Client';
  static const String managerRole = 'Manager';
  static bool isValidUserRole(role) =>
      role == clientRole || role == managerRole;

  // static String getFirebaseAuthErrorMessage(String errorCode) {
  //   switch (errorCode) {
  //     case 'user-not-found':
  //       return 'No user found for that email.';
  //     case 'invalid-credential':
  //       return 'Incorrect password provided for that user.';
  //     case 'email-already-in-use':
  //       return 'The account already exists for that email.';
  //     case 'invalid-email':
  //       return 'The email address is not valid.';
  //     case 'user-disabled':
  //       return 'This user account has been disabled.';
  //     case 'operation-not-allowed':
  //       return 'Operation is not allowed.';
  //     default:
  //       return 'An unknown error occurred: $errorCode';
  //   }
  // }

  static String? validateName(String name) {
    if (name.isEmpty) return 'Name cannot be empty';
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) return 'Email cannot be empty';
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (!emailRegex.hasMatch(email)) return 'Invalid email address';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
