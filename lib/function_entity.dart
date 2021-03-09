class FunctionEntity {
  final bool isOperator;
  final double numberValue;
  final Operator type;

  FunctionEntity(this.isOperator, this.numberValue, this.type);
}

enum Operator { leftParen, rightParen, plus, minus, divide, multiply }
