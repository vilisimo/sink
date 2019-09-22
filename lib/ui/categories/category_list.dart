import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';

import 'category.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        var expenseCategories = vm.categories
            .where((Category category) => category.type == CategoryType.EXPENSE)
            .toList();
        var expense =
            TypedCategoryList(type: "Expenses", categories: expenseCategories);

        var incomeCategories = vm.categories
            .where((Category category) => category.type == CategoryType.INCOME)
            .toList();
        var income =
            TypedCategoryList(type: "Income", categories: incomeCategories);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            centerTitle: true,
            title: Text('Categories'),
          ),
          body: Scrollbar(
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              children: <Widget>[
                expense,
                income,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  Set<Category> categories;

  _ViewModel({@required this.categories});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(categories: getCategories(store.state));
  }
}

class TypedCategoryList extends StatelessWidget {
  final List<Category> categories;
  final String type;

  TypedCategoryList({@required this.type, @required this.categories});

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          this.type,
          style: Theme.of(context).textTheme.subhead,
        ),
      )
    ];
    tiles
      ..addAll(
        categories.map<Widget>((Category c) => CategoryTile(c)).toList(),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tiles,
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CategoryIcon(
        iconData: icons[category.icon],
        color: category.color,
        isActive: true,
      ),
      title: Text(category.name),
    );
  }
}
