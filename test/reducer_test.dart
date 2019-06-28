import 'package:flutter/material.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/reducers.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/palette.dart';
import 'package:test/test.dart';

main() {
  test('DeleteEntry action appends an entry to a entries kept for undo', () {
    var entries = [
      Entry(
        id: '1',
        amount: 1.0,
        date: DateTime.now(),
        categoryId: 'a',
        description: 'b',
        type: EntryType.EXPENSE,
      ),
    ];
    var state = AppState(removed: entries);

    var entry = Entry(
      id: '2',
      amount: 2.0,
      date: DateTime.now(),
      categoryId: 'c',
      description: 'd',
      type: EntryType.INCOME,
    );
    var newState = reduce(state, DeleteEntry(entry));

    expect(newState.removed.length, 2);
    expect(newState.removed[1], state.removed[1]);
  });

  test('UndoDelete action removes last entry from a list', () {
    var entries = [
      Entry(
        id: '2',
        amount: 2.0,
        date: DateTime.now(),
        categoryId: 'c',
        description: 'd',
        type: EntryType.EXPENSE,
      ),
      Entry(
        id: '3',
        amount: 3.0,
        date: DateTime.now(),
        categoryId: 'e',
        description: 'f',
        type: EntryType.INCOME,
      )
    ];

    var state = AppState(removed: entries);

    var newState = reduce(state, UndoDelete());

    expect(newState.removed.length, 1);
    expect(newState.removed.contains(entries[0]), isTrue);
  });

  test('Non-existent action results in the same state', () {
    var entries = [
      Entry(
        id: '1',
        amount: 1.0,
        date: DateTime.now(),
        categoryId: 'a',
        description: 'b',
        type: EntryType.EXPENSE,
      ),
      Entry(
        id: '2',
        amount: 2.0,
        date: DateTime.now(),
        categoryId: 'c',
        description: 'd',
        type: EntryType.INCOME,
      )
    ];
    var state = AppState(removed: entries);

    var newState = reduce(state, null);

    expect(newState, state);
  });

  test('LoadCategories returns a state with categories from an action', () {
    Set<Category> categories = Set.from([
      Category(
        id: "1",
        name: "category 1",
        icon: "",
        color: Colors.grey,
        type: null,
      ),
      Category(
        id: "2",
        name: "category 2",
        icon: "",
        color: Colors.blue,
        type: null,
      ),
    ]);

    var state = AppState(areCategoriesLoading: true);

    var newState = reduce(state, ReloadCategories(categories));

    expect(newState.categories, categories);
    expect(newState.areCategoriesLoading, false);
  });

  test('LoadColors returns a state with colors', () {
    var state = AppState();

    var newState = reduce(state, ReloadColors(Set.from([])));

    expect(newState.availableColors, materialColors);
  });

  test('LoadColors returns a state with intersection of colors', () {
    var state = AppState();

    var newState = reduce(state, ReloadColors(Set.from([Colors.red])));

    expect(newState.availableColors, isNotEmpty);
    expect(newState.availableColors.contains(Colors.red), false);
  });
}
