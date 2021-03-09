import 'package:stack/stack.dart';
import 'package:rpn_calculator/expression_parser.dart';
import 'package:rpn_calculator/expression_validator.dart';
import 'package:rpn_calculator/function_entity.dart';

class RpnCalculator {
  Stack<FunctionEntity> _operators;
  Stack<FunctionEntity> _operands;
  ExpressionValidator _validator;
  ExpressionParser _parser;

  RpnCalculator() {
    this._operands = new Stack<FunctionEntity>();
    this._operators = new Stack<FunctionEntity>();
    this._validator = new ExpressionValidator();
    this._parser = new ExpressionParser(this._validator);
  }

  double evaluate(String expression) {
    this._operands = new Stack<FunctionEntity>();
    this._operators = new Stack<FunctionEntity>();
    expression = expression.replaceAll(' ', '');
    // Throws if expression is invalid
    this._validator.validate(expression);
    // Throws if expression fails to parse
    var entityExpression = this._parser.parseExpression(expression);
  }

  void _readInTokens() {}

  void _processOperators() {}
}

class RpnCalculationException implements Exception {
  final String msg;
  const RpnCalculationException(this.msg);
  String toString() => 'RpnCalculationException: $msg';
}
