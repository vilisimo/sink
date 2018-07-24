import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:test/test.dart';

main() {
  test('returns state with new values', () {
    final state = AppState(List());
    final now = DateTime.now();
    final entry = Entry(cost: 1.0, category: 'a', description: 'b', date: now);
    final entries = List<Entry>();
    entries.add(entry);

    final result = state.copyWith(
      entries: entries,
      lastEntry: entry,
      lastEntryIndex: 0,
    );

    expect(result.entries, entries);
    expect(result.lastEntry, entry);
    expect(result.lastEntryIndex, 0);
  });
}
