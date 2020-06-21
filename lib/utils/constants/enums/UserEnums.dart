enum FirstLogin {
  FALSE,
  TRUE
}

enum LoginType {
  EMAIL_LOGIN_TYPE,
  GMAIL_LOGIN_TYPE,
  FACEBOOK_LOGIN_TYPE
}

enum LoginState {
  ERROR_USER_NOT_FOUND,
  ERROR_WRONG_PASSWORD,
  ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL,
  ERROR_EMAIL_ALREADY_IN_USE,
  ERROR_NETWORK_REQUEST_FAILED,
  ERROR_WEAK_PASSWORD,
  ERROR_INVALID_EMAIL,
  ERROR_BAD_LOGIN,
  UNKNOWN_ERROR,
  CANCELED_BY_THE_USER,
  SUCCESS,
}

class LoginErrorStringsMobile{
  static const String ERROR_USER_NOT_FOUND = "ERROR_USER_NOT_FOUND";
  static const String ERROR_WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
  static const String ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL =
      "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL";
  static const String ERROR_EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";
  static const String ERROR_NETWORK_REQUEST_FAILED = "ERROR_NETWORK_REQUEST_FAILED";
  static const String ERROR_WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
  static const String ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
}

class LoginErrorStringsWeb{

  static const String ERROR_USER_NOT_FOUND = "auth/user-not-found";
  static const String ERROR_WRONG_PASSWORD = "auth/wrong-password";
  static const String ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL =
      "auth/account-exists-with-diferent-credential";
  static const String ERROR_EMAIL_ALREADY_IN_USE = "auth/email-already-in-use";
  static const String ERROR_NETWORK_REQUEST_FAILED = "auth/network-request-failed";
  static const String ERROR_WEAK_PASSWORD = "auth/weak-password";
  static const String ERROR_INVALID_EMAIL = "auth/invalid-email";

}