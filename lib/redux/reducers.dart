import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
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

    default:
      return state;
  }
}
