import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/reducers.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/palette.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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

  test('Loads month range', () {
    var state = AppState();
    var from = DateTime(2000, 1);
    var to = DateTime(2000, 3);

    var result = reduce(state, LoadMonths(from, to));

    expect(
      result.viewableMonths,
      DoubleLinkedQueue.from(
        [DateTime(2000, 3), DateTime(2000, 2), DateTime(2000, 1)],
      ),
    );
  });

  test("Loads more than a year's worth of months", () {
    var state = AppState();
    var from = DateTime(2000, 1);
    var to = DateTime(2001, 3);

    var result = reduce(state, LoadMonths(from, to));

    expect(
      result.viewableMonths,
      DoubleLinkedQueue.from([
        DateTime(2001, 3),
        DateTime(2001, 2),
        DateTime(2001, 1),
        DateTime(2000, 12),
        DateTime(2000, 11),
        DateTime(2000, 10),
        DateTime(2000, 9),
        DateTime(2000, 8),
        DateTime(2000, 7),
        DateTime(2000, 6),
        DateTime(2000, 5),
        DateTime(2000, 4),
        DateTime(2000, 3),
        DateTime(2000, 2),
        DateTime(2000, 1),
      ]),
    );
  });

  test('Loads one month range when from and to are the same month', () {
    var state = AppState();
    var from = DateTime(2000, 1, 1);
    var to = DateTime(2000, 1, 9);

    var result = reduce(state, LoadMonths(from, to));

    expect(result.viewableMonths, DoubleLinkedQueue.from([DateTime(2000, 1)]));
  });

  test('Substitutes existing months in a state', () {
    var state = AppState(
      viewableMonths: DoubleLinkedQueue<DateTime>.from([DateTime(2004, 8)]),
    );
    var from = DateTime(2003, 5, 18);
    var to = DateTime(2003, 8, 11);

    var result = reduce(state, LoadMonths(from, to));

    expect(
      result.viewableMonths,
      DoubleLinkedQueue.from([
        DateTime(2003, 8),
        DateTime(2003, 7),
        DateTime(2003, 6),
        DateTime(2003, 5),
      ]),
    );
  });

  test('Selects a month when no month is selected', () {
    var state = AppState();
    var from = DateTime(2000, 1);
    var to = DateTime(2000, 1);

    var result = reduce(state, LoadMonths(from, to));

    expect(
      result.viewableMonths,
      DoubleLinkedQueue.from([DateTime(2000, 1)]),
    );

    expect(
      result.selectedMonth,
      result.viewableMonths.lastEntry(),
    );
  });

  test('Overwrites the old entry with the one from current months queue', () {
    var state = AppState(selectedMonth: DoubleLinkedQueueEntry(DateTime.now()));
    var from = DateTime(2000, 1);
    var to = DateTime(2000, 1);

    var firstState = reduce(state, LoadMonths(from, to));
    expect(firstState.selectedMonth, firstState.viewableMonths.firstEntry());

    to = DateTime(2000, 2);
    var secondState = reduce(firstState, LoadMonths(from, to));

    expect(
      secondState.viewableMonths,
      DoubleLinkedQueue.from([DateTime(2000, 2), DateTime(2000, 1)]),
    );
    expect(
      secondState.selectedMonth,
      isNot(secondState.viewableMonths.firstEntry()),
    );
  });

  test('Sets stale selected month to first entry of viewable months', () {
    var state = AppState(
      selectedMonth: DoubleLinkedQueueEntry(DateTime(2000, 1)),
    );
    var from = DateTime(2000, 2);
    var to = DateTime(2000, 3);

    var result = reduce(state, LoadMonths(from, to));

    expect(result.selectedMonth, result.viewableMonths.lastEntry());
  });

  test('Selects a new month', () {
    var state = AppState(
      selectedMonth: DoubleLinkedQueueEntry(DateTime(2000, 1, 1)),
    );
    var newMonth = DoubleLinkedQueueEntry(DateTime(2000, 1, 2));

    var result = reduce(
      state,
      SelectMonth(newMonth),
    );

    expect(result.selectedMonth.element, newMonth.element);
  });

  test('RetrieveUser sets status to loading', () {
    var state = AppState(authStatus: AuthenticationStatus.ANONYMOUS);

    var result = reduce(state, RetrieveUser());

    expect(result.authStatus, AuthenticationStatus.LOADING);
  });

  test('SetUserId sets user id', () {
    var state = AppState(userId: null);

    var userId = Uuid().v4();
    var result = reduce(state, SetUserId(userId));

    expect(result.userId, userId);
  });

  test('SetUserId sets status to logged in when user id exists', () {
    var state = AppState(userId: null);

    var userId = Uuid().v4();
    var result = reduce(state, SetUserId(userId));

    expect(result.authStatus, AuthenticationStatus.LOGGED_IN);
  });

  test('SetUserId sets status to anonymous when user id does not exist', () {
    var state = AppState(userId: Uuid().v4());

    var result = reduce(state, SetUserId(null));

    expect(result.authStatus, AuthenticationStatus.ANONYMOUS);
    expect(result.userId, isNull);
  });
}
