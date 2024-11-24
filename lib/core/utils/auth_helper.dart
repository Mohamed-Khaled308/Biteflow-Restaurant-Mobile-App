class AuthHelper {
  static const String clientRole = 'Client';
  static const String managerRole = 'Manager';
  static bool isValidUserRole(role) =>
      role == clientRole || role == managerRole;
}
