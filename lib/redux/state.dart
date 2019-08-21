import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/theme/palette.dart';

@immutable
class AppState {
  final String userId;
  final AuthenticationStatus authStatus;
  final List<Entry> removed;
  final Set<Category> categories;
  // TODO: must be at least one default category
  final bool areCategoriesLoading;
  final Set<Color> availableColors;
  final DoubleLinkedQueueEntry<DateTime> selectedMonth;
  final DoubleLinkedQueue<DateTime> viewableMonths;

  AppState({
    userId,
    authStatus,
    removed,
    categories,
    areCategoriesLoading,
    availableColors,
    selectedMonth,
    viewableMonths,
  })  : this.userId = userId,
        this.authStatus = authStatus ?? AuthenticationStatus.ANONYMOUS,
        this.removed = removed ?? List(),
        this.categories = categories ?? Set(),
        this.areCategoriesLoading = areCategoriesLoading ?? true,
        this.availableColors = availableColors ?? Set.from(materialColors),
        this.selectedMonth = selectedMonth,
        this.viewableMonths = viewableMonths ??
            DoubleLinkedQueue.from([firstDay(DateTime.now())]);

  AppState copyWith({
    String userId,
    AuthenticationStatus authStatus,
    List<Entry> removed,
    Set<Category> categories,
    bool areCategoriesLoading,
    Set<Color> availableColors,
    DoubleLinkedQueueEntry<DateTime> selectedMonth,
    DoubleLinkedQueue<DateTime> viewableMonths,
  }) {
    return AppState(
      userId: userId,
      authStatus: authStatus ?? this.authStatus,
      removed: removed ?? this.removed,
      categories: categories ?? this.categories,
      areCategoriesLoading: areCategoriesLoading ?? this.areCategoriesLoading,
      availableColors: availableColors ?? this.availableColors,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      viewableMonths: viewableMonths ?? this.viewableMonths,
    );
  }
}
