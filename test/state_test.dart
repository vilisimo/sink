import 'package:flutter/material.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/state.dart';
import 'package:test/test.dart';

main() {
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
        Category(id: "1", name: "1", icon: "", color: Colors.white, type: null),
        Category(id: "2", name: "2", icon: "", color: Colors.blue, type: null),
        Category(id: "3", name: "3", icon: "", color: Colors.black, type: null),
      ]),
    );

    final category = Category(
      id: "4",
      name: "4",
      icon: "",
      color: Colors.pink,
      type: null,
    );
    final result = state.copyWith(categories: Set<Category>.from([category]));

    expect(result.categories, Set.from([category]));
  });

  test('returns state with old categories', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "1", icon: "", color: Colors.white, type: null),
        Category(id: "2", name: "2", icon: "", color: Colors.blue, type: null),
        Category(id: "3", name: "3", icon: "", color: Colors.black, type: null),
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
}
