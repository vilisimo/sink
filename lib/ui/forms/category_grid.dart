import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/colors.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/category_form.dart';

class CategoryGrid extends StatelessWidget {
  final Function(String) onTap;
  final String selected;

  CategoryGrid({@required this.onTap, @required this.selected});

  void _handleTap(String selected) {
    onTap(selected);
  }

  @override
  Widget build(BuildContext context) {
    Widget addCategoryTile = CategoryTile(
      handleTap: (filler) => showDialog(
            context: context,
            builder: (context) => CategoryForm(),
          ),
      category: "Add",
      color: null,
      isSelected: false,
    );

    return StoreConnector(
      converter: _CategoryGridViewModel.fromState,
      builder: (BuildContext context, _CategoryGridViewModel vm) {
        var cats = vm.categories
            .map((category) => CategoryTile(
                key: ObjectKey(category),
                handleTap: (_handleTap),
                category: category.name,
                color: category.color,
                isSelected: selected == category.name))
            .toList();
        cats.add(addCategoryTile);

        return GridView.count(
          shrinkWrap: true,
          primary: true,
          physics: BouncingScrollPhysics(),
          crossAxisCount: 4,
          children: cats,
        );
      },
    );
  }
}

class _CategoryGridViewModel {
  final Set<Category> categories;

  _CategoryGridViewModel({@required this.categories});

  static _CategoryGridViewModel fromState(Store<AppState> store) {
    return _CategoryGridViewModel(categories: getCategories(store.state));
  }
}

// TODO: could be generic circular tile
class CategoryTile extends StatelessWidget {
  final Function(String) handleTap;
  final String category;
  final bool isSelected;
  final Color color;

  CategoryTile({
    Key key,
    @required this.handleTap,
    @required this.category,
    @required this.isSelected,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          handleTap(category);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Color.fromRGBO(color.red, color.green, color.blue, .8)
                      : lightGrey,
                ),
                child: Icon(
                  // TODO: refactor when categories get their own icons
                  category == "Add" ? Icons.add : Icons.add_shopping_cart,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
