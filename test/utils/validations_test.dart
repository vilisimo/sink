import 'package:sink/exceptions/InvalidInput.dart';
import 'package:test/test.dart';
import 'package:sink/utils/validations.dart';

void main() {
  test('does not allow an empty string', () {
    expect(() => notEmpty(''), throwsA(new isInstanceOf<InvalidInput>()));
  });

  test('does not allow whitespaces', () {
    expect(() => notEmpty('   '), throwsA(new isInstanceOf<InvalidInput>()));
  });

  test('does not allow a null', () {
    expect(() => notEmpty(null), throwsA(new isInstanceOf<InvalidInput>()));
  });

  test('does allow a valid string', () {
    notEmpty('Valid');
  });

  test('does not allow an empty string instead of a number', () {
    expect(() => nonNegative(''), throwsA(new isInstanceOf<InvalidInput>()));
  });

  test('does not allow whitespaces in a number', () {
    expect(() => nonNegative('   '), throwsA(new isInstanceOf<InvalidInput>()));
  });

  test('does not allow a null instead of a number', () {
    expect(() => nonNegative(null), throwsA(new isInstanceOf<InvalidInput>()));
  });
  
  test('does not allow a negative number', () {
    expect(() => nonNegative('-1'), throwsA(new isInstanceOf<InvalidInput>()));
  });

  test('allows a valid number', () {
    expect(() => nonNegative('0'), throwsA(new isInstanceOf<InvalidInput>()));
  });
}
