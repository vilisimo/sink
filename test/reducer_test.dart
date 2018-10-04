import 'package:sink/actions/actions.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/reducers/reducers.dart';
import 'package:test/test.dart';

main() {

  test('DeleteEntry action appends an entry to a entries kept for undo', () {
    var entries = [
      Entry(id: '1', cost: 1.0, date: DateTime.now(), category: 'a', description: 'b',),
    ];
    var state = AppState(removed: entries);

    var entry = Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd');
    var newState = reduce(state, DeleteEntry(entry));

    expect(newState.removed.length, 2);
    expect(newState.removed[1], state.removed[1]);
  });

  test('UndoDelete action removes last entry from a list', () {
    var entries = [
      Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd',),
      Entry(id: '3', cost: 3.0, date: DateTime.now(), category: 'e', description: 'f',)
    ];

    var state = AppState(removed: entries);

    var newState = reduce(state, UndoDelete());

    expect(newState.removed.length, 1);
    expect(newState.removed.contains(entries[0]), isTrue);
  });

  test('Non-existent action results in the same state', () {
    var entries = [
      Entry(id: '1', cost: 1.0, date: DateTime.now(), category: 'a', description: 'b',),
      Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd',)
    ];
    var state = AppState(removed: entries);

    var newState = reduce(state, null);

    expect(newState, state);
  });
}