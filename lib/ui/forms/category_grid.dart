import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/colors.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/category_form.dart';

class CategoryGrid extends StatelessWidget {
  static const ADD_CATEGORY_ID = "Add";

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
      category: Category(
        id: ADD_CATEGORY_ID,
        name: ADD_CATEGORY_ID,
        color: null,
      ),
      isSelected: false,
    );

    return StoreConnector(
      converter: _CategoryGridViewModel.fromState,
      builder: (BuildContext context, _CategoryGridViewModel vm) {
        var cats = vm.categories
            .map((category) => CategoryTile(
                  key: ObjectKey(category),
                  handleTap: (_handleTap),
                  category: category,
                  isSelected: selected == category.id,
                ))
            .toList();
        cats.add(addCategoryTile);

        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: GridView.count(
            shrinkWrap: true,
            primary: true,
            physics: BouncingScrollPhysics(),
            crossAxisCount: 4,
            children: cats,
          ),
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
  final Category category;
  final bool isSelected;

  CategoryTile({
    Key key,
    @required this.handleTap,
    @required this.category,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = category.color;

    return Center(
      child: GestureDetector(
        onTap: () {
          handleTap(category.id);
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
                  category.id == CategoryGrid.ADD_CATEGORY_ID
                      ? Icons.add
                      // TODO: change it when categories get their own icons
                      : Icons.add_shopping_cart,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category.name, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
