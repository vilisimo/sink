import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';

import 'category.dart';

class CategoryList extends StatelessWidget {
  static const route = '/categories';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
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
                TypedCategoryList(type: "Expenses", categories: vm.expenses),
                TypedCategoryList(type: "Income", categories: vm.income),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  List<Category> income;
  List<Category> expenses;

  _ViewModel({@required this.income, @required this.expenses});

  static _ViewModel fromState(Store<AppState> store) {
    List<Category> income = [], expenses = [];
    getCategories(store.state).toList().forEach(
        (c) => c.type == CategoryType.INCOME ? income.add(c) : expenses.add(c));

    return _ViewModel(income: income, expenses: expenses);
  }
}

class TypedCategoryList extends StatelessWidget {
  final String type;
  final List<Widget> tiles;

  TypedCategoryList._(this.type, this.tiles);

  factory TypedCategoryList({
    @required String type,
    @required List<Category> categories,
  }) {
    List<Widget> tiles = [TypedCategoryTitle(type)];
    tiles.addAll(categories.map<Widget>((c) => CategoryTile(c)).toList());

    return TypedCategoryList._(type, tiles);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tiles,
    );
  }
}

class TypedCategoryTitle extends StatelessWidget {
  final String type;

  TypedCategoryTitle(this.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(this.type, style: Theme.of(context).textTheme.subhead),
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
