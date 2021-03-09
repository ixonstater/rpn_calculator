class ExpressionValidator {
  void validate(String expression) {
    int totalParens = 0;
    for (int i = 0; i < expression.length - 1; i++) {
      String current = expression[i];
      String next = expression[i + 1];

      if (!this.isValidCharacter(current)) {
        throw new RpnValidationException(
            "Invalid character found in expression: " + current);
      } else if (!this.isValidCharacter(next)) {
        throw new RpnValidationException(
            "Invalid character found in expression: " + next);
      } else if (this.isRightParen(current)) {
        totalParens++;
        if (!(this.isOperator(next) || this.isRightParen(next))) {
          throw new RpnValidationException(
              "`)` can only be followed by operators and other `)`.");
        }
      } else if (this.isLeftParen(current)) {
        totalParens--;
        if (!(this.isMinus(next) ||
            this.isLeftParen(next) ||
            this.isDigit(next))) {
          throw new RpnValidationException(
              "`(` can only be followed by digits, other `(` and `-`.");
        }
      } else if (this.isOperator(current)) {
        if (!(this.isDigit(next) ||
            this.isMinus(next) ||
            this.isLeftParen(next))) {
          throw new RpnValidationException(
              "Operators can only be followed by digits, `-` and `(`.");
        }
      } else if (this.isDigit(current)) {
        if (!(this.isDigit(next) ||
            this.isDecimal(next) ||
            this.isOperator(next) ||
            this.isRightParen(next))) {
          throw new RpnValidationException("Digits cannot be followed by `(`.");
        }
      }
    }

    String last = expression[expression.length - 1];
    bool isLastDigit = this.isDigit(last);
    bool isLastRightParen = this.isRightParen(last);
    if (!(isLastDigit || isLastRightParen)) {
      throw new RpnValidationException(
          "The last character in your expression must be either a digit or a `)`.");
    } else if (isLastRightParen) {
      totalParens++;
    }

    if (!(totalParens == 0)) {
      throw new RpnValidationException(
          "Left and right parenthesis mismatched.");
    }
  }

  bool isRightParen(String operatorStr) {
    return operatorStr == ")";
  }

  bool isLeftParen(String operatorStr) {
    return operatorStr == "(";
  }

  bool isPlus(String operatorStr) {
    return operatorStr == "+";
  }

  bool isMinus(String operatorStr) {
    return operatorStr == "-";
  }

  bool isDivide(String operatorStr) {
    return operatorStr == "/";
  }

  bool isMultiply(String operatorStr) {
    return operatorStr == "*";
  }

  bool isOperator(String operatorStr) {
    return this.isPlus(operatorStr) ||
        this.isMinus(operatorStr) ||
        this.isDivide(operatorStr) ||
        this.isMultiply(operatorStr);
  }

  bool isDigit(String operand) {
    return (this.isDecimal(operand)) || (double.tryParse(operand) != null);
  }

  bool isDecimal(String decimal) {
    return decimal == ".";
  }

  bool isValidCharacter(String character) {
    return this.isDecimal(character) ||
        this.isOperator(character) ||
        this.isDigit(character) ||
        this.isLeftParen(character) ||
        this.isRightParen(character);
  }
}

class RpnValidationException implements Exception {
  final String msg;
  const RpnValidationException(this.msg);
  String toString() => 'RpnValidationException: $msg';
}
