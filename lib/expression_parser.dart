import 'dart:io' show stdout;
import 'package:rpn_calculator/expression_validator.dart';
import 'package:rpn_calculator/function_entity.dart';

class ExpressionParser {
  final ExpressionValidator _validator;
  ExpressionParser(this._validator);

  List<FunctionEntity> parseExpression(String expression) {
    var entityExpression = this._translateToFunctionEntities(expression);
    var parsedExpression = _replaceUnaryOperators(entityExpression);
    this._printExpression(parsedExpression);
    return parsedExpression;
  }

  List<FunctionEntity> _replaceUnaryOperators(List<FunctionEntity> expression) {
    var parsedExpression = new List<FunctionEntity>();
    var index = new ReferenceIndex();
    while (index < expression.length) {
      var current = expression[index.val()];
      if (!_validator.isMinus(current.operatorStr)) {
        parsedExpression.add(current);
        index.inc();
      } else {
        this._removeMinus(expression, index);
      }
    }

    return parsedExpression;
  }

  void _removeMinus(List<FunctionEntity> expression, ReferenceIndex index) {
    bool replacingUnaryMinus = this.isUnaryMinus(index, expression);
    // Remove minus symbol
    expression.removeAt(index.val());
    // Insert multiplication symbol
    expression.insert(
        index.val(), new FunctionEntity(EntityType.operatorToken, null, "*"));
    // Insert negative one
    expression.insert(
        index.val(), new FunctionEntity(EntityType.number, -1, null));
    // Insert left parenthesis
    expression.insert(
        index.val(), new FunctionEntity(EntityType.leftParen, null, "("));

    // Start seeking parenthesis insert spot from this location
    int parenIndex = index.val() + 2;
    // If replacing a binary minus, insert the plus operator
    if (!replacingUnaryMinus) {
      parenIndex++;
      expression.insert(
          index.val(), new FunctionEntity(EntityType.operatorToken, null, "+"));
    }

    // Find correct insert location for closing parenthesis
    int parenthesisCount = 0;
    do {
      parenIndex++;
      if (expression[parenIndex].type == EntityType.leftParen) {
        parenthesisCount++;
      } else if (expression[parenIndex].type == EntityType.rightParen) {
        parenthesisCount--;
      }
    } while (parenthesisCount != 0);

    // We want to insert after the found element
    parenIndex++;

    // Insert closing parenthesis
    expression.insert(
        parenIndex, new FunctionEntity(EntityType.rightParen, null, ")"));
  }

  bool isUnaryMinus(ReferenceIndex index, List<FunctionEntity> expression) {
    // If the minus is the first expression character or else is preceeded
    // by an operator or a left paren it is a unary operator. If it does not
    // match those conditions then it is not a unary negative symbol and must
    // be replaced by a binary operator before proceeding.
    var previousType = expression[index.val() - 1].type;
    return index.val() == 0 ||
        (previousType == EntityType.operatorToken ||
            previousType == EntityType.leftParen);
  }

  List<FunctionEntity> _translateToFunctionEntities(String expression) {
    var entities = new List<FunctionEntity>();
    var index = new ReferenceIndex();
    while (index < expression.length) {
      String current = expression[index.val()];
      if (_validator.isOperator(current)) {
        entities
            .add(new FunctionEntity(EntityType.operatorToken, null, current));
      } else if (_validator.isLeftParen(current)) {
        entities.add(new FunctionEntity(EntityType.leftParen, null, current));
      } else if (_validator.isRightParen(current)) {
        entities.add(new FunctionEntity(EntityType.rightParen, null, current));
      } else if (_validator.isDigit(current)) {
        entities.add(new FunctionEntity(
            EntityType.number, this._parseNumber(expression, index), null));
      }

      index.inc();
    }

    return entities;
  }

  double _parseNumber(String expression, ReferenceIndex index) {
    String assembled = expression[index.val()];
    while (expression.length > index.val() + 1 &&
        (_validator.isDecimal(expression[index.val() + 1]) ||
            _validator.isDigit(expression[index.val() + 1]))) {
      index.inc();
      assembled += expression[index.val()];
    }

    double value = double.tryParse(assembled);
    if (value == null) {
      throw new RpnParserException(
          "Failed to parse double from given string: " + assembled);
    }

    return value;
  }

  void _printExpression(List<FunctionEntity> expression) {
    String expressionStr = "";
    expression.forEach((FunctionEntity x) {
      if (x.type == EntityType.number) {
        expressionStr += x.numberValue.toString();
      } else {
        expressionStr += x.operatorStr.toString();
      }
    });
    print(expressionStr);
  }
}

class ReferenceIndex {
  int index = 0;
  void inc() {
    this.index++;
  }

  int val() {
    return index;
  }

  bool operator <(int rhs) {
    return this.index < rhs;
  }

  bool operator >(int rhs) {
    return this.index > rhs;
  }

  bool operator <=(int rhs) {
    return this.index <= rhs;
  }

  bool operator >=(int rhs) {
    return this.index >= rhs;
  }
}

class RpnParserException implements Exception {
  final String msg;
  const RpnParserException(this.msg);
  String toString() => 'RpnParserException: $msg';
}
