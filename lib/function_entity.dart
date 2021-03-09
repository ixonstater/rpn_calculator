class FunctionEntity {
  final EntityType type;
  final double numberValue;
  final String operatorStr;

  FunctionEntity(this.type, this.numberValue, this.operatorStr);
}

enum EntityType { leftParen, rightParen, number, operatorToken }
