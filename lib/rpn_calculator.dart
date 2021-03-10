import 'dart:collection';

import 'package:rpn_calculator/expression_parser.dart';
import 'package:rpn_calculator/expression_validator.dart';
import 'package:rpn_calculator/function_entity.dart';

class RpnCalculator {
  late Queue<FunctionEntity> _operators;
  late Queue<FunctionEntity> _operands;
  late ExpressionValidator _validator;
  late ExpressionParser _parser;

  RpnCalculator() {
    this._operands = new Queue<FunctionEntity>();
    this._operators = new Queue<FunctionEntity>();
    this._validator = new ExpressionValidator();
    this._parser = new ExpressionParser(this._validator);
  }

  double evaluate(String expression) {
    this._operands = new Queue<FunctionEntity>();
    this._operators = new Queue<FunctionEntity>();
    expression = expression.replaceAll(' ', '');
    // Throws if expression is invalid
    this._validator.validate(expression);
    // Throws if expression fails to parse
    var entityExpression = this._parser.parseExpression(expression);
    this._readInTokens(entityExpression);
    return this._processRemainingOperators();
  }

  void _readInTokens(List<FunctionEntity> expression) {
    ReferenceIndex index = new ReferenceIndex();
    while (index < expression.length) {
      var token = expression[index.val()];
      if (token.type == EntityType.number) {
        this._operands.addFirst(token);
      } else if (token.type == EntityType.leftParen) {
        this._operators.addFirst(token);
      } else if (token.type == EntityType.rightParen) {
        this._handleRightParen();
      } else if (token.type == EntityType.operatorToken) {
        this._handleOperatorToken(token);
      }

      index.inc();
    }
  }

  void _handleRightParen() {
    while (this._operators.first.type != EntityType.leftParen) {
      this._popAndCalculate();
    }
    this._operators.removeFirst();
  }

  void _handleOperatorToken(FunctionEntity operatorToken) {
    while (!this._operators.isEmpty &&
        this._operators.first.sameOrGreaterPrecedence(operatorToken)) {
      this._popAndCalculate();
    }

    this._operators.addFirst(operatorToken);
  }

  void _popAndCalculate() {
    var operatorToken = this._operators.removeFirst();
    var rhs = this._operands.removeFirst();
    var lhs = this._operands.removeFirst();
    this._operands.addFirst(this._applyOperator(operatorToken, rhs, lhs));
  }

  double _processRemainingOperators() {
    while (!this._operators.isEmpty) {
      this._popAndCalculate();
    }

    return this._operands.removeFirst().numberValue;
  }

  FunctionEntity _applyOperator(
      FunctionEntity operatorToken, FunctionEntity rhs, FunctionEntity lhs) {
    if (_validator.isMinus(operatorToken.operatorStr)) {
      return lhs - rhs;
    } else if (_validator.isPlus(operatorToken.operatorStr)) {
      return lhs + rhs;
    } else if (_validator.isDivide(operatorToken.operatorStr)) {
      return lhs / rhs;
    } else {
      return lhs * rhs;
    }
  }
}

class RpnCalculationException implements Exception {
  final String msg;
  const RpnCalculationException(this.msg);
  String toString() => 'RpnCalculationException: $msg';
}
