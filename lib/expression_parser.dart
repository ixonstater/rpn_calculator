class ExpressionParser {}

class RpnParserException implements Exception {
  final String msg;
  const RpnParserException(this.msg);
  String toString() => 'RpnParserException: $msg';
}
