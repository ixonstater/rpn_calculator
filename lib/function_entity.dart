class FunctionEntity {
  final EntityType type;
  final double numberValue;
  final String operatorStr;

  FunctionEntity(this.type, this.numberValue, this.operatorStr);

  FunctionEntity operator -(FunctionEntity rhs) {
    this._canApplyNumericOperator(rhs);
    return new FunctionEntity(
        EntityType.number, this.numberValue - rhs.numberValue, "");
  }

  FunctionEntity operator +(FunctionEntity rhs) {
    this._canApplyNumericOperator(rhs);
    return new FunctionEntity(
        EntityType.number, this.numberValue + rhs.numberValue, "");
  }

  FunctionEntity operator *(FunctionEntity rhs) {
    this._canApplyNumericOperator(rhs);
    return new FunctionEntity(
        EntityType.number, this.numberValue * rhs.numberValue, "");
  }

  FunctionEntity operator /(FunctionEntity rhs) {
    this._canApplyNumericOperator(rhs);
    return new FunctionEntity(
        EntityType.number, this.numberValue / rhs.numberValue, "");
  }

  void _canApplyNumericOperator(FunctionEntity rhs) {
    if (!(this.type == EntityType.number && rhs.type == EntityType.number)) {
      throw new FunctionEntityException(
          "Cannot apply numeric operator to entity of type " +
              this.type.toString());
    }
  }

  bool sameOrGreaterPrecedence(FunctionEntity compare) {
    if (this.type == EntityType.leftParen) {
      return false;
    } else if (compare.operatorStr == "-" || compare.operatorStr == "+") {
      return true;
    } else if (compare.operatorStr == "*" || compare.operatorStr == "/") {
      if (this.operatorStr == "*" || this.operatorStr == "/") {
        return true;
      }
    }

    return false;
  }
}

enum EntityType { leftParen, rightParen, number, operatorToken }

class FunctionEntityException implements Exception {
  final String msg;
  const FunctionEntityException(this.msg);
  String toString() => 'FunctionEntityException: $msg';
}
