class BadLoginException implements Exception{
  final String message;
  BadLoginException([this.message = ""]);
}

class LoginCanceledException implements Exception{
  final String message;
  LoginCanceledException([this.message = ""]);
}