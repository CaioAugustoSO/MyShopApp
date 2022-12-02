class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail already exists!",
    "OPERATION_NOT_ALLOWED": "Operation not allowed!",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Too many attempts, try later!",
    "EMAIL_NOT_FOUND": "E-mail not found!",
    "INVALID_PASSWORD": "Invalid Password!",
    "USER_DISABLED": "User Disabled!",
  };
  final String key;

  const AuthException(this.key);

  String toString() {
    if (errors.containsKey(key)) {
      return errors[key].toString();
    } else {
      return "An error ocurred during the authentication";
    }
    return key;
  }
}
