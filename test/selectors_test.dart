import 'package:flutter/material.dart' as Material;
import 'package:sink/common/exceptions.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:test/test.dart';

main() {
  test('retrieves last removed entry', () {
    var state = AppState(removed: [
      Entry(cost: 1.0, date: DateTime.now(), categoryId: 'a', description: 'b'),
      Entry(cost: 2.0, date: DateTime.now(), categoryId: 'c', description: 'd'),
    ]);

    var entry = getLastRemoved(state);

    expect(entry, state.removed[1]);
  });

  test('retrieves a list of categories', () {
    var category =
        Category(id: "1", name: "category", color: Material.Colors.red);
    var state = AppState(categories: Set<Category>.from([category]));

    var categories = getCategories(state);

    expect(categories.length, 1);
    expect(categories.first, category);
  });

  test('retrieves used colors', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "category 1", color: Material.Colors.white),
        Category(id: "2", name: "category 2", color: Material.Colors.blue),
        Category(id: "3", name: "category 3", color: Material.Colors.black),
      ]),
    );

    var colors = getUsedColors(state);

    var expected = Set<Material.Color>.from(
        [Material.Colors.white, Material.Colors.blue, Material.Colors.black]);
    expect(colors.length, 3);
    expect(colors, expected);
  });

  test('should retrieve a category by id', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "category 1", color: Material.Colors.white),
        Category(id: "2", name: "category 2", color: Material.Colors.blue),
        Category(id: "3", name: "category 3", color: Material.Colors.black),
      ]),
    );

    var category = getCategory(state, "2");

    expect(category,
        Category(id: "2", name: "category 2", color: Material.Colors.blue));
  });

  test('should indicate that a category could not be found', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "category 1", color: Material.Colors.white),
        Category(id: "2", name: "category 2", color: Material.Colors.blue),
        Category(id: "3", name: "category 3", color: Material.Colors.black),
      ]),
    );

    expect(
      () => getCategory(state, "51"),
      throwsA(TypeMatcher<CategoryNotFound>()),
    );
  });

  test('indicates wheter the categories are loading', () {
    var state = AppState();
    expect(areCategoriesLoading(state), true);

    state = state.copyWith(areCategoriesLoading: false);
    expect(areCategoriesLoading(state), false);
  });
}
