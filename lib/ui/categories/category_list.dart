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
              children:
                  vm.categories.map((Category c) => CategoryTile(c)).toList(),
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
