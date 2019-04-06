import 'package:sink/models/entry.dart';
import 'package:test/test.dart';

void main() {
  test('returns an empty entry', () {
    final Entry entry = Entry.empty();

    expect(entry.id, isNotNull);
    expect(entry.date, isNotNull);
    expect(entry.amount, isNull);
    expect(entry.description, '');
    expect(entry.categoryId, '');
  });
}
