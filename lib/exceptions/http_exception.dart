class HttpException implements Exception {
  final String msg;

  const HttpException(this.msg);

  String toString() {
    return msg;
  }
}
