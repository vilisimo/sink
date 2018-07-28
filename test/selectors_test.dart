import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/selectors/selectors.dart';
import 'package:test/test.dart';

main() {
  test('get entries retrieves entries from a state', () {
    var state = AppState([
      Entry(cost: 1.0, date: DateTime.now(), category: 'a', description: 'b'),
      Entry(cost: 2.0, date: DateTime.now(), category: 'c', description: 'd'),
    ]);

    var entries = getEntries(state);

    expect(entries, state.entries);
  });
}