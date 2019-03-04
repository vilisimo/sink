import 'package:flutter/services.dart';
import 'package:sink/common/input_formatter.dart';
import 'package:test/test.dart';

main() {
  DecimalInputFormatter formatter = DecimalInputFormatter();

  test('considers empty string a valid input', () {
    var input = '';

    expect(formatter.isValid(input), true);
  });

  test('considers a proper decimal a valid input', () {
    expect(formatter.isValid('.2'), true);
    expect(formatter.isValid('1.22'), true);
    expect(formatter.isValid('0.2'), true);
    expect(formatter.isValid('-0.2'), true);
    expect(formatter.isValid('+0.2'), true);
  });

  test('recognizes invalid or unusual decimal input', () {
    expect(formatter.isValid('00'), false);
    expect(formatter.isValid('06'), false);
    expect(formatter.isValid('06'), false);
    expect(formatter.isValid('001'), false);
    expect(formatter.isValid('1 0'), false);
    expect(formatter.isValid('1. 0'), false);
    expect(formatter.isValid(' 1.0'), false);
  });

  test('does not allow more than two digits precision', () {
    expect(formatter.isValid("1.001"), false);
  });

  test('returns old value when next one is invalid', () {
    var valid = TextEditingValue(text: "1.0");
    var invalid = TextEditingValue(text: "invalid");

    var result = formatter.formatEditUpdate(valid, invalid);

    expect(result, valid);
  });

  test('returns new value when next one is valid', () {
    var old = TextEditingValue(text: "1.0");
    var next = TextEditingValue(text: "12.5");

    var result = formatter.formatEditUpdate(old, next);

    expect(result, next);
  });
}
