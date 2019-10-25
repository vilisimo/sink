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

  test('SetUserDetails sets user id', () {
    var state = AppState(userId: null);

    var userId = Uuid().v4();
    var result = reduce(state, SetUserDetails(id: userId, email: ""));

    expect(result.userId, userId);
  });

  test('SetUserDetails sets status to logged in when user id exists', () {
    var state = AppState(userId: null);

    var result = reduce(state, SetUserDetails(id: Uuid().v4(), email: ""));

    expect(result.authStatus, AuthenticationStatus.LOGGED_IN);
  });

  test('SetUserDetails sets status to anonymous when user id does not exist', () {
    var state = AppState(userId: Uuid().v4());

    var result = reduce(state, SetUserDetails(id: "", email: ""));

    expect(result.authStatus, AuthenticationStatus.ANONYMOUS);
    expect(result.userId, isNull);
  });

  test('SetUserDetails sets user email', () {
    var state = AppState(userEmail: null);

    var result = reduce(state, SetUserDetails(id: "", email: "email"));

    expect(result.userEmail, "email");
  });

  test('StartRegistration marks registration as ongoing', () {
    var state = AppState(registrationInProgress: false);

    var result = reduce(state, StartRegistration());

    expect(result.registrationInProgress, true);
  });

  test('StartRegistration marks registration success as false', () {
    var state = AppState(registrationSuccess: true);

    var result = reduce(state, StartRegistration());

    expect(result.registrationSuccess, false);
  });

  test('ReportRegistrationSuccess marks registration process as false', () {
    var state = AppState(registrationInProgress: true);

    var result = reduce(state, ReportRegistrationSuccess());

    expect(result.registrationInProgress, false);
  });

  test('ReportRegistrationSuccess marks registration success as true', () {
    var state = AppState(registrationSuccess: false);

    var result = reduce(state, ReportRegistrationSuccess());

    expect(result.registrationSuccess, true);
  });

  test('ReportRegistrationSuccess clears errors', () {
    var state = AppState(authenticationErrorMessage: "Error");

    var result = reduce(state, ReportRegistrationSuccess());

    expect(result.authenticationErrorMessage, "");
  });

  test('ReportAuthenticationError sets authentication error', () {
    var state = AppState(authenticationErrorMessage: "");

    var result = reduce(state, ReportAuthenticationError("code"));

    expect(result.authenticationErrorMessage, "code");
  });

  test('ReportAuthenticationError sets progress flags to false', () {
    var state = AppState(
      authenticationErrorMessage: "",
      signInInProgress: true,
      registrationInProgress: true,
    );

    var result = reduce(state, ReportAuthenticationError("code"));

    expect(result.authenticationErrorMessage, "code");
    expect(result.signInInProgress, false);
    expect(result.registrationInProgress, false);
  });

  test('ReportAuthenticationError returns message on email already in use', () {
    var state = AppState(authenticationErrorMessage: "");

    var result = reduce(
      state,
      ReportAuthenticationError("ERROR_EMAIL_ALREADY_IN_USE"),
    );

    expect(
      result.authenticationErrorMessage,
      "Supplied email address is already taken.",
    );
  });

  test('ReportAuthenticationError resets flag on email already in use', () {
    var state = AppState(
      authenticationErrorMessage: "",
      registrationInProgress: true,
    );

    var result = reduce(
      state,
      ReportAuthenticationError("ERROR_EMAIL_ALREADY_IN_USE"),
    );

    expect(result.registrationInProgress, false);
  });

  test('ReportAuthenticationError returns message on incorrect password', () {
    var state = AppState(authenticationErrorMessage: "");

    var result = reduce(
      state,
      ReportAuthenticationError("ERROR_WRONG_PASSWORD"),
    );

    expect(
      result.authenticationErrorMessage,
      "Email and password do not match.",
    );
  });

  test('ReportAuthenticationError resets progress flag on incorrect password',
      () {
    var state = AppState(
      authenticationErrorMessage: "",
      signInInProgress: true,
    );

    var result = reduce(
      state,
      ReportAuthenticationError("ERROR_WRONG_PASSWORD"),
    );

    expect(result.signInInProgress, false);
  });

  test('ReportAuthenticationError resets progress flag on incorrect user', () {
    var state = AppState(
      authenticationErrorMessage: "",
      signInInProgress: true,
    );

    var result = reduce(
      state,
      ReportAuthenticationError("ERROR_USER_NOT_FOUND"),
    );

    expect(result.signInInProgress, false);
  });

  test('ClearRegistrationState clears error message', () {
    var state = AppState(authenticationErrorMessage: "Error");

    var result = reduce(state, ClearAuthenticationState());

    expect(result.authenticationErrorMessage, "");
  });

  test('ClearRegistrationState clears registration success', () {
    var state = AppState(registrationSuccess: true);

    var result = reduce(state, ClearAuthenticationState());

    expect(result.registrationSuccess, false);
  });

  test('SigIn indicates that sign in is in progress', () {
    var state = AppState(signInInProgress: false);

    var result = reduce(state, SignIn(email: 'email', password: 'password'));

    expect(result.signInInProgress, true);
  });

  test('ReportRegistrationSuccess indicates sign in is not in progress', () {
    var state = AppState(signInInProgress: true);

    var result = reduce(state, ReportSignInSuccess());

    expect(result.signInInProgress, false);
  });

  test('ReportRegistrationSuccess removes authentication errors', () {
    var state = AppState(authenticationErrorMessage: "Error");

    var result = reduce(state, ReportSignInSuccess());

    expect(result.authenticationErrorMessage, "");
  });

  test('InitializeDatabase creates a database instance', () {
    var state = AppState(database: null);

    var result = reduce(state, InitializeDatabase("user", true));

    expect(result.database, isNotNull);
  });
}
