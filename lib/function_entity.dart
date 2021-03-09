class FunctionEntity {
  final EntityType type;
  final double numberValue;
  final String operatorStr;

  FunctionEntity(this.type, this.numberValue, this.operatorStr);

  FunctionEntity operator -(FunctionEntity rhs) {
    return new FunctionEntity(
        EntityType.number, this.numberValue - rhs.numberValue, null);
  }

  FunctionEntity operator +(FunctionEntity rhs) {
    return new FunctionEntity(
        EntityType.number, this.numberValue + rhs.numberValue, null);
  }

  FunctionEntity operator *(FunctionEntity rhs) {
    return new FunctionEntity(
        EntityType.number, this.numberValue * rhs.numberValue, null);
  }

  FunctionEntity operator /(FunctionEntity rhs) {
    return new FunctionEntity(
        EntityType.number, this.numberValue / rhs.numberValue, null);
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
