import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/theme/palette.dart';

const MONTHS_IN_YEAR = 12;

AppState reduce(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case DeleteEntry:
      // a hack that fixes flickering of entry upon its removal.
      // TODO: Why does returning new state cause a flicker?
      state.removed.add(action.entry);
      return state;

    case UndoDelete:
      List<Entry> removed = List.from(state.removed);
      removed.removeLast();
      return state.copyWith(removed: removed);

    case LoadMonths:
      var months = dateRange(action.from, action.to);
      var linkedMonths = DoubleLinkedQueue<DateTime>.from(months);
      var curr = state.selectedMonth;
      if (curr == null) {
        curr = linkedMonths.firstEntry();
      } else {
        var last = linkedMonths.firstEntry();
        while (last.nextEntry() != null && last.element != curr.element) {
          last = last.nextEntry();
        }
        if (last == null) {
          curr = linkedMonths.lastEntry();
        } else {
          curr = last;
        }
      }

      return state.copyWith(
        viewableMonths: linkedMonths,
        selectedMonth: curr,
      );

    case SelectMonth:
      return state.copyWith(selectedMonth: action.month);

    case ReloadCategories:
      return state.copyWith(
        categories: Set.from(action.categories),
        areCategoriesLoading: false,
      );

    case ReloadColors:
      Set<Color> used = Set.from(action.usedColors);
      return state.copyWith(availableColors: materialColors.difference(used));

    case RetrieveUser:
      return state.copyWith(authStatus: AuthenticationStatus.LOADING);

    case SetUserDetails:
      final anonymous = isEmpty(action.id);
      final status = anonymous
          ? AuthenticationStatus.ANONYMOUS
          : AuthenticationStatus.LOGGED_IN;

      return state.copyWith(
        userId: action.id,
        userEmail: action.email,
        authStatus: status,
      );

    case StartRegistration:
      return state.copyWith(
          registrationInProgress: true, registrationSuccess: false);

    case ReportRegistrationSuccess:
      return state.copyWith(
        registrationInProgress: false,
        registrationSuccess: true,
        authenticationErrorMessage: "",
      );

    case SignIn:
      return state.copyWith(signInInProgress: true);

    case ReportSignInSuccess:
      return state.copyWith(
        signInInProgress: false,
        authenticationErrorMessage: "",
      );

    case ReportAuthenticationError:
      switch (action.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return state.copyWith(
            authenticationErrorMessage:
                "Supplied email address is already taken.",
            registrationInProgress: false,
          );

        case "ERROR_WRONG_PASSWORD":
          return state.copyWith(
            authenticationErrorMessage: "Email and password do not match.",
            signInInProgress: false,
          );

        case "ERROR_USER_NOT_FOUND":
          return state.copyWith(
            authenticationErrorMessage: "User could not be not found.",
            signInInProgress: false,
          );
      }
      return state.copyWith(
        authenticationErrorMessage: action.code,
        registrationInProgress: false,
        signInInProgress: false,
      );

    case ClearAuthenticationState:
      return state.copyWith(
        authenticationErrorMessage: "",
        registrationSuccess: false,
      );

    case InitializeDatabase:
      return state.copyWith(
        database: action.test
            ? TestFirestoreDatabase()
            : FirestoreDatabase(action.userId),
      );

    default:
      return state;
  }
}
