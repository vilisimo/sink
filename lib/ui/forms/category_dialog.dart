import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';
import 'package:sink/theme/palette.dart' as Palette;
import 'package:sink/ui/categories/category.dart';
import 'package:sink/ui/common/text_input.dart';
import 'package:sink/ui/forms/color_grid.dart';
import 'package:uuid/uuid.dart';

import 'icon_grid.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryType type;

  CategoryDialog({@required this.type});

  @override
  State<StatefulWidget> createState() => CategoryDialogState();
}

class CategoryDialogState extends State<CategoryDialog>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String _categoryName;
  String _iconName;
  Color _color;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void handleSave(Function(String, Color, String) onSave) {
    onSave(_categoryName, _color, _iconName);
    Navigator.of(context).pop();
  }

  bool hasData() {
    return !isBlank(_categoryName) && !isBlank(_iconName) && _color != null;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DialogViewModel>(
      converter: (state) => _DialogViewModel.fromState(state, widget.type),
      builder: (BuildContext context, _DialogViewModel vm) {
        Set<Color> colors = vm.availableColors;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: CategoryIcon(
                          iconData: icons[_iconName],
                          color: _color ?? Colors.white,
                          isActive: true,
                        ),
                      ),
                      Expanded(
                        child: UndecoratedTextInput(
                          hintText: "Enter category name",
                          value: _categoryName,
                          onChange: (String newName) => setState(() {
                            this._categoryName = newName;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: new TabBar(
                    indicatorColor: Colors.red,
                    labelColor: Theme.of(context).textTheme.title.color,
                    controller: _tabController,
                    tabs: [
                      new Tab(text: 'Icon'),
                      new Tab(text: 'Color'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      IconGrid(
                        selectedCategory: _iconName,
                        selectedColor: _color ?? Palette.lightGrey,
                        onTap: (String newCategory) => setState(() {
                          _iconName = newCategory;
                        }),
                      ),
                      ColorGrid(
                        selectedColor: _color,
                        onTap: (Color newColor) => setState(() {
                          _color = newColor;
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
              child: FlatButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Palette.discouraged,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: FlatButton(
                child: Text("Add"),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: hasData() ? () => handleSave(vm.onSave) : null,
                disabledColor: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DialogViewModel {
  final Function(String, Color, String) onSave;
  final Set<Color> availableColors;

  _DialogViewModel({
    @required this.onSave,
    @required this.availableColors,
  });

  static _DialogViewModel fromState(
    Store<AppState> store,
    CategoryType type,
  ) {
    return _DialogViewModel(
      availableColors: getAvailableColors(store.state),
      onSave: (category, color, iconName) {
        store.dispatch(
          CreateCategory(
            Category(
              id: Uuid().v4(),
              name: category,
              icon: iconName,
              color: color,
              type: type,
            ),
          ),
        );
      },
    );
  }
}
