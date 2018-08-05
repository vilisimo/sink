import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:test/test.dart';

main() {
  test('returns state with new values', () {
    final state = AppState(List());
    final now = DateTime.now();
    final removed = [Entry(cost: 1.0, category: 'a', description: 'b', date: now)];
    final entries = List<Entry>();
    entries.add(removed[0]);

    final result = state.copyWith(
      entries: entries,
      removed: removed,
    );

    expect(result.entries, entries);
    expect(result.removed, removed);
  });

  test('returns state with old values', () {
    final now = DateTime.now();
    final entry = Entry(cost: 1.0, category: 'a', description: 'b', date: now);
    final state = AppState(List(), removed: [entry]);

    final result = state.copyWith(entries: null);

    expect(result.entries, state.entries);
    expect(result.removed, state.removed);
  });
}
