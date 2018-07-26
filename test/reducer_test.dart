import 'package:sink/actions/actions.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/reducers/reducers.dart';
import 'package:test/test.dart';

main() {
  test('AddEntry action appends an entry to entries list', () {
    var entries = [
      Entry(cost: 1.0, date: DateTime.now(), category: 'a', description: 'b')
    ];
    var state = AppState(entries);

    var entry = Entry(cost: 99.99, date: DateTime.now(), category: 'c', description: 'd');
    var newState = reduce(state, AddEntry(entry));

    expect(newState.entries.length, 2);
    expect(newState.entries[1], entry);
  });

  test('EditEntry action edits a matching entry', () {
    var entries = [
      Entry(id: '1', cost: 1.0, date: DateTime.now(), category: 'a', description: 'b',),
      Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd',)
    ];
    var state = AppState(entries);

    var entry = Entry(id: '2', cost: 3.0, date: DateTime.now(), category: 'e', description: 'f');
    var newState = reduce(state, EditEntry(entry));

    expect(newState.entries.length, 2);
    expect(newState.entries[1], entry);
  });

  test('DeleteEntry action deletes an entry', () {
    var entries = [
      Entry(id: '1', cost: 1.0, date: DateTime.now(), category: 'a', description: 'b',),
      Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd',)
    ];
    var state = AppState(entries);

    var newState = reduce(state, DeleteEntry(entries[0], 0));

    expect(newState.entries.length, 1);
    expect(newState.entries[0], state.entries[1]);
  });

  test('UndoDelete action inserts an entry into its old position', () {
    var entries = [
      Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd',),
      Entry(id: '3', cost: 3.0, date: DateTime.now(), category: 'e', description: 'f',)
    ];
    var entry = Entry(id: '2', cost: 3.0, date: DateTime.now(), category: 'a', description: 'b');
    var state = AppState(entries, lastEntry: entry, lastEntryIndex: 0);

    var newState = reduce(state, UndoDelete());

    expect(newState.entries.length, 3);
    expect(newState.entries[0], entry);
  });

  test('Non-existent action results in the same state', () {
    var entries = [
      Entry(id: '1', cost: 1.0, date: DateTime.now(), category: 'a', description: 'b',),
      Entry(id: '2', cost: 2.0, date: DateTime.now(), category: 'c', description: 'd',)
    ];
    var state = AppState(entries);

    var newState = reduce(state, null);

    expect(newState, state);
  });
}