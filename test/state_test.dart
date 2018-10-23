import 'package:sink/models/entry.dart';
import 'package:sink/redux/state.dart';
import 'package:test/test.dart';

main() {
  test('returns state with new values', () {
    final state = AppState(removed: List<Entry>());
    final now = DateTime.now();
    final removed = [Entry(cost: 1.0, category: 'a', description: 'b', date: now)];
    final entries = List<Entry>();
    entries.add(removed[0]);

    final result = state.copyWith(
      removed: removed,
    );

    expect(result.removed, removed);
  });

  test('returns state with old values', () {
    final now = DateTime.now();
    final entry = Entry(cost: 1.0, category: 'a', description: 'b', date: now);
    final state = AppState(removed: [entry]);

    final result = state.copyWith(removed: null);

    expect(result.removed, state.removed);
  });
}
