import 'package:rpn_calculator/expression_validator.dart';
import 'package:test/test.dart';

class ExpressionValidatorTest {
  ExpressionValidator _validator = new ExpressionValidator();
  List<String> _digits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.'
  ];
  List<String> _operators = ['+', '-', '*', '/'];

  void defineTests() {
    this.testValidate();
    this.testIsRightParen();
    this.testIsLeftParen();
    this.testIsPlus();
    this.testIsMinus();
    this.testIsDivide();
    this.testIsMultiply();
    this.testIsOperator();
    this.testIsDigit();
    this.testIsDecimal();
    this.testIsValidCharacter();
  }

  void testValidate() {
    test("validate should throw if the last character is not a digit or a ')'",
        () {
      expect(() => _validator.validate("(2+10)1"),
          throwsA(TypeMatcher<RpnValidationException>()));
      expect(() => _validator.validate("(2+10)+"),
          throwsA(TypeMatcher<RpnValidationException>()));
    });

    test("validate should throw on invalid characters", () {
      expect(() => _validator.validate("0+7-3*4,"),
          throwsA(TypeMatcher<RpnValidationException>()));
      expect(() => _validator.validate("0+7-3*4&"),
          throwsA(TypeMatcher<RpnValidationException>()));
      expect(() => _validator.validate("0+7-3*4k"),
          throwsA(TypeMatcher<RpnValidationException>()));
    });

    test("`)` followed by invalid character should throw", () {
      _digits.forEach((element) => {
            expect(() => _validator.validate("(" + element),
                throwsA(TypeMatcher<RpnValidationException>()))
          });

      expect(() => _validator.validate('()('),
          throwsA(TypeMatcher<RpnValidationException>()));
    });

    test("`(` followed by invalid character should throw", () {
      ['+', '*', '/', ')'].forEach((element) {
        expect(() => _validator.validate("(" + element),
            throwsA(TypeMatcher<RpnValidationException>()));
      });
    });

    test("operator followed by invalid character should throw", () {
      ['+', '*', '/'].forEach((element) {
        expect(() => _validator.validate("+" + element),
            throwsA(TypeMatcher<RpnValidationException>()));
      });
    });

    test("digits followed by invalid character should throw", () {
      expect(() => _validator.validate("1("),
          throwsA(TypeMatcher<RpnValidationException>()));
    });
  }

  void testIsRightParen() {
    test("isRightParen returns true on encountering ')'", () {
      var result = _validator.isRightParen(')');
      expect(result, true);
    });
    test("isRightParen returns false on encountering '('", () {
      var result = _validator.isRightParen('(');
      expect(result, false);
    });
  }

  void testIsLeftParen() {
    test("isLeftParen returns true on encountering '('", () {
      var result = _validator.isLeftParen('(');
      expect(result, true);
    });
    test("isLeftParen returns false on encountering ')'", () {
      var result = _validator.isLeftParen(')');
      expect(result, false);
    });
  }

  void testIsPlus() {
    test("isPlus returns true on encountering '+'", () {
      var result = _validator.isPlus('+');
      expect(result, true);
    });
    test("isPlus returns false on encountering '-'", () {
      var result = _validator.isPlus('-');
      expect(result, false);
    });
  }

  void testIsMinus() {
    test("isMinus returns true on encountering '-'", () {
      expect(_validator.isMinus('-'), true);
    });
    test("isMinus returns false on encountering '+'", () {
      expect(_validator.isMinus('+'), false);
    });
  }

  void testIsDivide() {
    test("isDivide returns true on encountering '/'", () {
      expect(_validator.isDivide('/'), true);
    });
    test("isDivide returns false on encountering '*'", () {
      expect(_validator.isDivide('*'), false);
    });
  }

  void testIsMultiply() {
    test("isMultiply returns true on encountering '*'", () {
      expect(_validator.isMultiply('*'), true);
    });
    test("isMultiply returns false on encountering '/'", () {
      expect(_validator.isMultiply('/'), false);
    });
  }

  void testIsOperator() {
    test("isOperator returns true on encountering operator", () {
      _operators.forEach((element) {
        expect(_validator.isOperator(element), true);
      });
    });
    test("isOperator returns false on encountering digit", () {
      _digits.forEach((element) {
        expect(_validator.isOperator(element), false);
      });
    });
  }

  void testIsDigit() {
    test("isDigit returns true on encountering digit", () {
      _digits.forEach((element) {
        expect(_validator.isDigit(element), true);
      });
    });
    test("isDigit returns false on encountering '+'", () {
      expect(_validator.isDigit('+'), false);
    });
  }

  void testIsDecimal() {
    test("isDecimal returns true on encountering '.'", () {
      expect(_validator.isDecimal('.'), true);
    });
    test("isDecimal returns false on encountering '+'", () {
      expect(_validator.isDecimal('+'), false);
    });
  }

  void testIsValidCharacter() {
    test("isValidCharacter returns true on encountering digit", () {
      _digits.forEach((element) {
        expect(_validator.isValidCharacter(element), true);
      });
    });
    test("isValidCharacter returns true on encountering operator", () {
      _operators.forEach((element) {
        expect(_validator.isValidCharacter(element), true);
      });
    });
    test("isValidCharacter returns true on encountering parenthesis", () {
      ['(', ')'].forEach((element) {
        expect(_validator.isValidCharacter(element), true);
      });
    });
  }
}

void main() {
  var expressionValidatorTest = new ExpressionValidatorTest();
  expressionValidatorTest.defineTests();
}
