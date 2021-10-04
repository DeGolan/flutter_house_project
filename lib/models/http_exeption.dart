class HttpExeption implements Exception {
  final String massage;

  HttpExeption(this.massage);

  @override
  String toString() {
    return massage;
    //return super.toString();
  }
}
