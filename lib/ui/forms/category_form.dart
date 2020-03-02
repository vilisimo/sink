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

class CategoryFormArgs {
  final CategoryType type;

  CategoryFormArgs(this.type);
}

class CategoryForm extends StatefulWidget {
  static const route = '/categoryForm';

  @override
  CategoryFormState createState() => CategoryFormState();
}

class CategoryFormState extends State<CategoryForm> {
  String categoryName;
  Color color;
  String iconName;

  void handleNameChange(String newName) {
    setState(() {
      this.categoryName = newName;
    });
  }

  void handleColorTap(Color color) {
    setState(() {
      this.color = color;
    });
  }

  void handleIconTap(String newIconName) {
    setState(() {
      this.iconName = newIconName;
    });
  }

  void handleSave(
    Function(String, Color, String) onSave,
    Color fallbackColor,
    BuildContext context,
  ) {
    onSave(categoryName, color ?? fallbackColor, iconName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final CategoryFormArgs args = ModalRoute.of(context).settings.arguments;
    return StoreConnector<AppState, _ViewModel>(
      converter: (state) => _ViewModel.fromState(state, args.type),
      builder: (BuildContext context, _ViewModel vm) {
        Set<Color> colors = vm.availableColors;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text('New Category'),
            actions: <Widget>[
              IconButton(
                disabledColor: Colors.grey,
                iconSize: 28.0,
                icon: Icon(Icons.check),
                onPressed: !isBlank(categoryName) && !isBlank(iconName)
                    ? () => handleSave(vm.onSave, colors.first, context)
                    : null,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClearableTextInput(
                      hintText: "Category Name",
                      onChange: (value) => handleNameChange(value),
                    ),
                  ),
                  ColorGrid(selectedColor: color, onTap: handleColorTap),
                  IconGrid(
                    selectedColor: color ?? colors.first,
                    onTap: handleIconTap,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Function(String, Color, String) onSave;
  final Set<Color> usedColors;
  final Set<Color> availableColors;

  _ViewModel({
    @required this.onSave,
    @required this.usedColors,
    @required this.availableColors,
  });

  static _ViewModel fromState(
    Store<AppState> store,
    CategoryType type,
  ) {
    return _ViewModel(
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
      usedColors: getUsedColors(store.state),
      availableColors: getAvailableColors(store.state),
    );
  }
}

class CategoryDialog extends StatefulWidget {
  final CategoryType type;

  CategoryDialog({@required this.type});

  @override
  State<StatefulWidget> createState() => CategoryDialogState();
}

class CategoryDialogState extends State<CategoryDialog>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String _category;
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

  @override
  Widget build(BuildContext context) {
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
                      iconData: icons[_category],
                      color: _color ?? Colors.white,
                      isActive: true,
                    ),
                  ),
                  Text('Category name'),
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
                    selectedCategory: _category,
                    selectedColor: _color ?? Palette.lightGrey,
                    onTap: (String newCategory) => setState(() {
                      _category = newCategory;
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
            onPressed: () => print("TODO: implement save"),
          ),
        ),
      ],
    );
  }
}
