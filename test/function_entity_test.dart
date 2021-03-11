import 'package:rpn_calculator/function_entity.dart';
import 'package:test/test.dart';

class FunctionEntityTest {
  void defineTests() {
    this.testOperatorMinus();
    this.testOperatorPlus();
    this.testOperatorMultiply();
    this.testOperatorDivide();
    this.testSameOrGreaterPrecedence();
  }

  void testOperatorMinus() {
    test("minus operator should do subtraction", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.number, 5, "");
      var result = lhs - rhs;
      expect(result.numberValue, 5);
    });

    test("minus operator should throw on invalid argument", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.operatorToken, 5, "");
      expect(() => lhs - rhs, throwsA(TypeMatcher<FunctionEntityException>()));

      lhs = new FunctionEntity(EntityType.operatorToken, 10, "");
      rhs = new FunctionEntity(EntityType.number, 5, "");
      expect(() => lhs - rhs, throwsA(TypeMatcher<FunctionEntityException>()));
    });
  }

  void testOperatorPlus() {
    test("plus operator should do addition", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.number, 5, "");
      var result = lhs + rhs;
      expect(result.numberValue, 15);
    });

    test("plus operator should throw on invalid argument", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.operatorToken, 5, "");
      expect(() => lhs + rhs, throwsA(TypeMatcher<FunctionEntityException>()));

      lhs = new FunctionEntity(EntityType.operatorToken, 10, "");
      rhs = new FunctionEntity(EntityType.number, 5, "");
      expect(() => lhs + rhs, throwsA(TypeMatcher<FunctionEntityException>()));
    });
  }

  void testOperatorMultiply() {
    test("multiply operator should do multiplication", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.number, 5, "");
      var result = lhs * rhs;
      expect(result.numberValue, 50);
    });

    test("multiply operator should throw on invalid argument", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.operatorToken, 5, "");
      expect(() => lhs * rhs, throwsA(TypeMatcher<FunctionEntityException>()));

      lhs = new FunctionEntity(EntityType.operatorToken, 10, "");
      rhs = new FunctionEntity(EntityType.number, 5, "");
      expect(() => lhs * rhs, throwsA(TypeMatcher<FunctionEntityException>()));
    });
  }

  void testOperatorDivide() {
    test("divide operator should do division", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.number, 5, "");
      var result = lhs / rhs;
      expect(result.numberValue, 2);
    });

    test("divide operator should throw on invalid argument", () {
      var lhs = new FunctionEntity(EntityType.number, 10, "");
      var rhs = new FunctionEntity(EntityType.operatorToken, 5, "");
      expect(() => lhs / rhs, throwsA(TypeMatcher<FunctionEntityException>()));

      lhs = new FunctionEntity(EntityType.operatorToken, 10, "");
      rhs = new FunctionEntity(EntityType.number, 5, "");
      expect(() => lhs / rhs, throwsA(TypeMatcher<FunctionEntityException>()));
    });
  }

  void testSameOrGreaterPrecedence() {
    var plus = new FunctionEntity(EntityType.operatorToken, 0, "+");
    var minus = new FunctionEntity(EntityType.operatorToken, 0, "-");
    var multiply = new FunctionEntity(EntityType.operatorToken, 0, "*");
    var divide = new FunctionEntity(EntityType.operatorToken, 0, "/");
    var leftParen = new FunctionEntity(EntityType.leftParen, 0, "(");

    test("addition precedences", () {
      expect(plus.sameOrGreaterPrecedence(minus), true);
      expect(plus.sameOrGreaterPrecedence(divide), false);
      expect(plus.sameOrGreaterPrecedence(multiply), false);
      expect(plus.sameOrGreaterPrecedence(plus), true);
      expect(plus.sameOrGreaterPrecedence(leftParen), false);
    });

    test("minus precedences", () {
      expect(minus.sameOrGreaterPrecedence(minus), true);
      expect(minus.sameOrGreaterPrecedence(divide), false);
      expect(minus.sameOrGreaterPrecedence(multiply), false);
      expect(minus.sameOrGreaterPrecedence(plus), true);
      expect(minus.sameOrGreaterPrecedence(leftParen), false);
    });

    test("divide precedences", () {
      expect(divide.sameOrGreaterPrecedence(minus), true);
      expect(divide.sameOrGreaterPrecedence(divide), true);
      expect(divide.sameOrGreaterPrecedence(multiply), true);
      expect(divide.sameOrGreaterPrecedence(plus), true);
      expect(divide.sameOrGreaterPrecedence(leftParen), false);
    });

    test("multiply precedences", () {
      expect(multiply.sameOrGreaterPrecedence(minus), true);
      expect(multiply.sameOrGreaterPrecedence(divide), true);
      expect(multiply.sameOrGreaterPrecedence(multiply), true);
      expect(multiply.sameOrGreaterPrecedence(plus), true);
      expect(multiply.sameOrGreaterPrecedence(leftParen), false);
    });

    test("parenthesis precedences", () {
      expect(leftParen.sameOrGreaterPrecedence(minus), false);
      expect(leftParen.sameOrGreaterPrecedence(divide), false);
      expect(leftParen.sameOrGreaterPrecedence(multiply), false);
      expect(leftParen.sameOrGreaterPrecedence(plus), false);
      expect(leftParen.sameOrGreaterPrecedence(leftParen), false);
    });
  }
}

void main() {
  var tester = new FunctionEntityTest();
  tester.defineTests();
}
