class HttpExcaption implements Exception {
  final String message;
  HttpExcaption(this.message);

  @override
  String toString() {
    return message;
  }
}
