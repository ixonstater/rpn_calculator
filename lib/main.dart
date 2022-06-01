import 'dart:io';
import 'package:rpn_calculator/rpn_calculator.dart';

void main(List<String> args) {
  RpnCalculator calc = new RpnCalculator();
  while (true) {
    stdout.write("Enter expression or q to exit: ");
    var line = stdin.readLineSync();
    if (line == "q") {
      print("Exiting.");
      return;
    }
    if (line == null){
      print("Got null line");
      continue;
    }
    try {
      var val = calc.evaluate(line);
      print("Result: $val");
    }catch (e){
      print(e.toString());
    }
  }
}
