class BadLoginException implements Exception{
  final String message;
  BadLoginException([this.message = ""]);
}