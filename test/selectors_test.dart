import 'package:flutter/material.dart' as Material;
import 'package:sink/common/exceptions.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:test/test.dart';

const white = Material.Colors.white;
const blue = Material.Colors.blue;
final black = Material.Colors.black;

main() {
  test('retrieves last removed entry', () {
    var state = AppState(removed: [
      Entry(
        cost: 1.0,
        date: DateTime.now(),
        categoryId: 'a',
        description: 'b',
        type: EntryType.EXPENSE,
      ),
      Entry(
        cost: 2.0,
        date: DateTime.now(),
        categoryId: 'c',
        description: 'd',
        type: EntryType.EXPENSE,
      ),
    ]);

    var entry = getLastRemoved(state);

    expect(entry, state.removed[1]);
  });

  test('retrieves used colors', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "category 1", color: white, type: null),
        Category(id: "2", name: "category 2", color: blue, type: null),
        Category(id: "3", name: "category 3", color: black, type: null),
      ]),
    );

    var colors = getUsedColors(state);

    var expected = Set<Material.Color>.from([white, blue, black]);
    expect(colors.length, 3);
    expect(colors, expected);
  });

  test('retrieves a set of categories', () {
    var category = Category(
      id: "1",
      name: "category",
      color: Material.Colors.red,
      type: null,
    );
    var state = AppState(categories: Set<Category>.from([category]));

    var categories = getCategories(state);

    expect(categories.length, 1);
    expect(categories.first, category);
  });

  test('retrieves a set of expense categories', () {
    var first = Category(
        id: "1",
        name: "expense 1",
        color: Material.Colors.red,
        type: CategoryType.EXPENSE);

    var second = Category(
        id: "2",
        name: "expense 2",
        color: Material.Colors.red,
        type: CategoryType.INCOME);

    var third = Category(
        id: "3",
        name: "income",
        color: Material.Colors.red,
        type: CategoryType.EXPENSE);

    var st = AppState(categories: Set<Category>.from([first, second, third]));

    var result = getExpenseCategories(st);

    expect(result.length, 2);
    expect(result, Set.from([first, third]));
  });

  test('does not retrieve any expense categories from empty set', () {
    var state = AppState(categories: Set<Category>.from([]));

    var result = getExpenseCategories(state);

    expect(result.length, 0);
  });

  test('retrieves a set of income categories', () {
    var first = Category(
        id: "1",
        name: "expense 1",
        color: Material.Colors.red,
        type: CategoryType.EXPENSE);

    var second = Category(
        id: "2",
        name: "expense 2",
        color: Material.Colors.red,
        type: CategoryType.INCOME);

    var third = Category(
        id: "3",
        name: "income",
        color: Material.Colors.red,
        type: CategoryType.EXPENSE);

    var st = AppState(categories: Set<Category>.from([first, second, third]));

    var result = getIncomeCategories(st);

    expect(result.length, 1);
    expect(result, Set.from([second]));
  });

  test('does not retrieve any income categories from empty set', () {
    var state = AppState(categories: Set<Category>.from([]));

    var result = getIncomeCategories(state);

    expect(result.length, 0);
  });

  test('should retrieve a category by id', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "category 1", color: white, type: null),
        Category(id: "2", name: "category 2", color: blue, type: null),
        Category(id: "3", name: "category 3", color: black, type: null),
      ]),
    );

    var category = getCategory(state, "2");

    expect(category,
        Category(id: "2", name: "category 2", color: blue, type: null));
  });

  test('should indicate that a category could not be found', () {
    var state = AppState(
      categories: Set<Category>.from([
        Category(id: "1", name: "category 1", color: white, type: null),
        Category(id: "2", name: "category 2", color: blue, type: null),
        Category(id: "3", name: "category 3", color: black, type: null),
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
