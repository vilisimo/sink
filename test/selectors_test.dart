import 'package:flutter/material.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:test/test.dart';

main() {
  test('retrieves last removed entry', () {
    var state = AppState(removed: [
      Entry(cost: 1.0, date: DateTime.now(), category: 'a', description: 'b'),
      Entry(cost: 2.0, date: DateTime.now(), category: 'c', description: 'd'),
    ]);

    var entry = getLastRemoved(state);

    expect(entry, state.removed[1]);
  });

  test('retrieves a list of categories', () {
    var category = Category(id: "1", name: "category", color: Colors.red);
    var state = AppState(categories: Set<Category>.from([category]));

    var categories = getCategories(state);

    expect(categories.length, equals(1));
    expect(categories.first, equals(category));
  });
}
