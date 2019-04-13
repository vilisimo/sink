import 'package:sink/models/expenditure.dart';
import 'package:test/test.dart';

main() {
  test('expenditure with greater amount is considered to be greater', () {
    var greater = Expenditure<String>(bucket: "filler", amount: 1.0);
    var smaller = Expenditure<String>(bucket: "filler", amount: 0.0);

    expect(greater.compareTo(smaller), greaterThan(0));
  });

  test('expenditure with smaller amount is considered to be smaller', () {
    var greater = Expenditure<String>(bucket: "filler", amount: 1.0);
    var smaller = Expenditure<String>(bucket: "filler", amount: 0.0);

    expect(smaller.compareTo(greater), lessThan(0));
  });

  test('expenditure with equal amount is considered to be smaller', () {
    var e1 = Expenditure<String>(bucket: "filler", amount: 1.0);
    var e2 = Expenditure<String>(bucket: "filler", amount: 1.0);

    expect(e1.compareTo(e2), 0);
  });
}
