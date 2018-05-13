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
}
