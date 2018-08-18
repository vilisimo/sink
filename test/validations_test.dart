import 'package:sink/exceptions/InvalidInput.dart';
import 'package:test/test.dart';
import 'package:sink/utils/validations.dart';

void main() {
  test('does not allow an empty string', () {
    expect(() => notEmpty(''), throwsA(isInstanceOf<InvalidInput>()));
  });

  test('does not allow whitespaces', () {
    expect(() => notEmpty('   '), throwsA(isInstanceOf<InvalidInput>()));
  });

  test('does not allow a null', () {
    expect(() => notEmpty(null), throwsA(isInstanceOf<InvalidInput>()));
  });

  test('does allow a valid string', () {
    notEmpty('Valid');
  });

  test('does not allow an empty string instead of a number', () {
    expect(() => nonNegative(''), throwsA(isInstanceOf<InvalidInput>()));
  });

  test('does not allow whitespaces in a number', () {
    expect(() => nonNegative('   '), throwsA(isInstanceOf<InvalidInput>()));
  });

  test('does not allow a null instead of a number', () {
    expect(() => nonNegative(null), throwsA(isInstanceOf<InvalidInput>()));
  });
  
  test('does not allow a negative number', () {
    expect(() => nonNegative('-1'), throwsA(isInstanceOf<InvalidInput>()));
  });

  test('allows a valid number', () {
    expect(() => nonNegative('0'), throwsA(isInstanceOf<InvalidInput>()));
  });
}
