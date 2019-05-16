import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/common/text_input.dart';
import 'package:sink/ui/forms/color_grid.dart';
import 'package:uuid/uuid.dart';

import 'icon_grid.dart';

class CategoryForm extends StatefulWidget {
  final CategoryType type;

  CategoryForm({@required this.type});

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
    onSave(categoryName, color == null ? fallbackColor : color, iconName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (state) => _ViewModel.fromState(state, widget.type),
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
                  ColorGrid(colors: colors, onTap: handleColorTap),
                  IconGrid(
                      selectedColor: color ?? colors.first,
                      onTap: handleIconTap),
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
