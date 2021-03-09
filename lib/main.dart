import 'rpn_calculator.dart';

void main(List<String> args) {
  RpnCalculator calc = new RpnCalculator();
  calc.evaluate("(1 + 10 /(-19.22*15-10+(8+-2)))");
}
