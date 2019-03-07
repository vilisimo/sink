import 'package:sink/common/checks.dart' as Checks;
import 'package:test/test.dart';

void main() {
  test('indicates that string is empty when it is null', () {
    expect(Checks.isEmpty(null), true);
  });

  test('indicates that empty string is empty', () {
    expect(Checks.isEmpty(""), true);
  });

  test('indicates that string made up of empty spaces is empty', () {
    expect(Checks.isEmpty("    "), true);
  });
}
