import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

main() {
  test('returns state with new userId', () {
    var state = AppState(userId: Uuid().v4());

    final newUserId = Uuid().v4();
    final result = state.copyWith(userId: newUserId);

    expect(result.userId, newUserId);
  });

  test('returns state with userId as null to facilitate logging out', () {
    var state = AppState(userId: Uuid().v4());

    final result = state.copyWith(userId: "");

    expect(result.userId, isNull);
  });

  test('returns state with new user email', () {
    var state = AppState(userEmail: Uuid().v4());

    final result = state.copyWith(userEmail: "email");

    expect(result.userEmail, "email");
  });

  test('returns state with null user email', () {
    var state = AppState(userEmail: Uuid().v4());

    final result = state.copyWith(userEmail: "");

    expect(result.userEmail, isNull);
  });

  test('does not void user email when it is not passed in', () {
    var state = AppState(userEmail: "email");

    final result = state.copyWith(userId: "email is not passed");

    expect(result.userEmail, "email");
  });

  test('returns state with new authentication status', () {
    var state = AppState(authStatus: AuthenticationStatus.ANONYMOUS);

    final result = state.copyWith(authStatus: AuthenticationStatus.LOADING);

    expect(result.authStatus, AuthenticationStatus.LOADING);
  });

  test('returns state with old authentication status', () {
    var state = AppState(authStatus: AuthenticationStatus.ANONYMOUS);

    final result = state.copyWith(authStatus: null);

    expect(result.authStatus, AuthenticationStatus.ANONYMOUS);
  });

  test('returns state with new values', () {
    final state = AppState(removed: List<Entry>());
    final now = DateTime.now();
    final removed = [
      Entry(
        amount: 1.0,
        categoryId: 'a',
        description: 'b',
        date: now,
        type: EntryType.EXPENSE,
      )
    ];
    final entries = List<Entry>();
    entries.add(removed[0]);

    final result = state.copyWith(
      removed: removed,
    );

    expect(result.removed, removed);
  });

  test('returns state with old values', () {
    final now = DateTime.now();
    final entry = Entry(
      amount: 1.0,
      categoryId: 'a',
      description: 'b',
      date: now,
      type: EntryType.EXPENSE,
    );
    final state = AppState(removed: [entry]);

    final result = state.copyWith(removed: null);

    expect(result.removed, state.removed);
  });

  test('returns state with new categories', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: '1', name: '1', icon: '', color: Colors.white, type: null),
        Category(id: '2', name: '2', icon: '', color: Colors.blue, type: null),
        Category(id: '3', name: '3', icon: '', color: Colors.black, type: null),
      ]),
    );

    final category = Category(
      id: '4',
      name: '4',
      icon: '',
      color: Colors.pink,
      type: null,
    );
    final result = state.copyWith(categories: Set<Category>.from([category]));

    expect(result.categories, Set.from([category]));
  });

  test('returns state with old categories', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: '1', name: '1', icon: '', color: Colors.white, type: null),
        Category(id: '2', name: '2', icon: '', color: Colors.blue, type: null),
        Category(id: '3', name: '3', icon: '', color: Colors.black, type: null),
      ]),
    );

    final result = state.copyWith(categories: null);

    expect(result.categories, state.categories);
  });

  test('returns state with a new categories loading indicator', () {
    var state = AppState(areCategoriesLoading: true);

    final result = state.copyWith(areCategoriesLoading: false);

    expect(result.areCategoriesLoading, false);
  });

  test('returns state with old categories loading indicator', () {
    var state = AppState(areCategoriesLoading: true);

    final result = state.copyWith(areCategoriesLoading: null);

    expect(result.areCategoriesLoading, state.areCategoriesLoading);
  });

  test('returns state with new colors', () {
    var state = AppState(availableColors: Set<Color>.from([Colors.red]));

    final newColors = Set<Color>.from([Colors.green]);
    final result = state.copyWith(availableColors: newColors);

    expect(result.availableColors, newColors);
  });

  test('returns state with old colors', () {
    var state = AppState(availableColors: Set<Color>.from([Colors.red]));

    final result = state.copyWith(availableColors: null);

    expect(result.availableColors, state.availableColors);
  });

  test('returns state with new selected month', () {
    var state = AppState(
      selectedMonth: DoubleLinkedQueueEntry(DateTime.now()),
    );

    final newPeriod = DoubleLinkedQueueEntry(DateTime(2000, 1, 1, 0));
    final result = state.copyWith(selectedMonth: newPeriod);

    expect(result.selectedMonth, newPeriod);
  });

  test('returns state with old selected month', () {
    var state = AppState(
      selectedMonth: DoubleLinkedQueueEntry(DateTime(2000, 1, 1)),
    );

    final result = state.copyWith(selectedMonth: null);

    expect(result.selectedMonth, state.selectedMonth);
  });

  test('returns state with new viewable months list', () {
    var months = DoubleLinkedQueue<DateTime>.from(
      [DateTime(2000, 1), DateTime(2000, 2)],
    );
    var state = AppState(viewableMonths: months);

    final newMonths = DoubleLinkedQueue<DateTime>.from([
      DateTime(2001, 1),
      DateTime(2001, 2),
    ]);
    final result = state.copyWith(viewableMonths: newMonths);

    expect(result.viewableMonths, newMonths);
  });

  test('returns state with old viewable months list', () {
    var months = DoubleLinkedQueue<DateTime>.from(
      [DateTime(2000, 1), DateTime(2000, 2)],
    );
    var state = AppState(viewableMonths: months);

    final result = state.copyWith(viewableMonths: null);

    expect(result.viewableMonths, state.viewableMonths);
  });

  test('returns state with new registering flag', () {
    var state = AppState(registrationInProgress: true);

    final result = state.copyWith(registrationInProgress: false);

    expect(result.registrationInProgress, false);
  });

  test('returns state with old registering flag', () {
    var state = AppState(registrationInProgress: true);

    final result = state.copyWith(registrationInProgress: null);

    expect(result.registrationInProgress, state.registrationInProgress);
  });

  test('returns state with new registration success flag', () {
    var state = AppState(registrationSuccess: true);

    final result = state.copyWith(registrationSuccess: false);

    expect(result.registrationSuccess, false);
  });

  test('returns state with old registration success flag', () {
    var state = AppState(registrationInProgress: true);

    final result = state.copyWith(registrationSuccess: null);

    expect(result.registrationSuccess, state.registrationSuccess);
  });

  test('returns state with new authentication error', () {
    var state = AppState(authenticationErrorMessage: "Old");

    final result = state.copyWith(authenticationErrorMessage: "New");

    expect(result.authenticationErrorMessage, "New");
  });

  test('returns state with old authentication error', () {
    var state = AppState(authenticationErrorMessage: "Old");

    final result = state.copyWith(authenticationErrorMessage: null);

    expect(result.authenticationErrorMessage, state.authenticationErrorMessage);
  });

  test('returns state with new sign in progress indicator', () {
    var state = AppState(signInInProgress: true);

    final result = state.copyWith(signInInProgress: false);

    expect(result.signInInProgress, false);
  });

  test('returns state with old sign in progress indicator', () {
    var state = AppState(signInInProgress: true);

    final result = state.copyWith(signInInProgress: null);

    expect(result.signInInProgress, true);
  });

  test('returns state with new firestore repository', () {
    var state = AppState(database: TestFirestoreDatabase());

    final database = TestFirestoreDatabase();
    final result = state.copyWith(database: database);

    expect(result.database, database);
  });

  test('returns state with old firestore repository', () {
    final database = TestFirestoreDatabase();
    var state = AppState(database: database);

    final result = state.copyWith(database: null);

    expect(result.database, database);
  });
}
