import 'package:sink/common/enums.dart';
import 'package:sink/models/entry.dart';
import 'package:test/test.dart';

void main() {
  test('converts enum to string', () {
    var result = toString(EntryType.EXPENSE);

    expect(result, 'expense');
  });

  test('converts enum to capitalized string', () {
    var result = toCapitalizedString(EntryType.INCOME);

    expect(result, 'Income');
  });

  test('converts enums to capitalized string list', () {
    var result = toCapitalizedStringList(EntryType.values);

    expect(result, List.from(['Expense', 'Income']));
  });

  test('converts string to enum regardless of capitalization', () {
    var result = toEntryType('ExpENse');

    expect(result, EntryType.EXPENSE);
  });
}
