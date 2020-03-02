import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';
import 'package:sink/theme/palette.dart' as Palette;
import 'package:sink/ui/categories/category.dart';
import 'package:sink/ui/forms/category_dialog.dart';

class CategoryGrid extends StatefulWidget {
  static const ADD_CATEGORY_ID = "Add";

  final Function(String) onTap;
  final String selected;
  final CategoryType type;

  CategoryGrid({
    @required this.onTap,
    @required this.selected,
    @required this.type,
  });

  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  void _handleTap(String selected) {
    widget.onTap(selected);
  }

  @override
  Widget build(BuildContext context) {
    Widget addCategoryTile = CategoryTile(
      handleTap: (_) {
        showDialog(
          context: context,
          builder: (context) => CategoryDialog(type: widget.type),
        );
      },
      category: Category(
        id: CategoryGrid.ADD_CATEGORY_ID,
        name: CategoryGrid.ADD_CATEGORY_ID,
        icon: 'add',
        color: null,
        type: null,
      ),
      isSelected: false,
    );

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (BuildContext context, _ViewModel vm) {
        var cats = vm
            .categories(widget.type)
            .map((category) => CategoryTile(
                  key: ObjectKey(category),
                  handleTap: (_handleTap),
                  category: category,
                  isSelected: widget.selected == category.id,
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

class _ViewModel {
  final AppState state;

  _ViewModel({@required this.state});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(state: store.state);
  }

  /// A hack since [StoreConnector] does not update on type change.
  Set<Category> categories(CategoryType type) {
    return type == CategoryType.INCOME
        ? getIncomeCategories(state)
        : getExpenseCategories(state);
  }
}

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
    return Center(
      child: GestureDetector(
        onTap: () {
          handleTap(category.id);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CategoryIcon(
              iconData: icons[category.icon],
              color: isSelected ? category.color : Palette.lightGrey,
              isActive: isSelected,
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
