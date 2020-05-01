class NotLoggedInException implements Exception{
  final String message;
  NotLoggedInException([this.message = ""]);
}