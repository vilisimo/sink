import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/common/text_input.dart';
import 'package:sink/ui/forms/color_grid.dart';
import 'package:uuid/uuid.dart';

class CategoryForm extends StatefulWidget {
  @override
  CategoryFormState createState() {
    return CategoryFormState();
  }
}

class CategoryFormState extends State<CategoryForm> {
  List<Color> colors;

  String categoryName;
  Color color;
  bool saveable = false;

  @override
  void initState() {
    colors = List.from(Colors.primaries);
    colors.addAll(Colors.accents);
    super.initState();
  }

  void handleNameChange(String newName) {
    setState(() {
      this.categoryName = newName;
      this.saveable = categoryName != null && categoryName != "";
    });
  }

  void handleColorTap(Color color) {
    setState(() {
      this.color = color;
    });
  }

  void handleSave(Function(String, Color) onSave, BuildContext context) {
    onSave(categoryName, color == null ? colors[0] : color);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _CategoryFormViewModel.fromState,
      builder: (BuildContext context, _CategoryFormViewModel vm) {
        colors.removeWhere((color) => vm.usedColors
            .contains(Color.fromRGBO(color.red, color.green, color.blue, 1.0)));

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text('New Category'),
            actions: <Widget>[
              IconButton(
                disabledColor: Colors.grey,
                iconSize: 28.0,
                icon: Icon(Icons.check),
                onPressed:
                    saveable ? () => handleSave(vm.onSave, context) : null,
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClearableTextInput(
                  hintText: "Category Name",
                  onChange: (value) => handleNameChange(value),
                ),
              ),
              ColorGrid(colors: colors, onTap: handleColorTap),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryFormViewModel {
  final Function(String, Color) onSave;
  final Set<Color> usedColors;

  _CategoryFormViewModel({@required this.onSave, @required this.usedColors});

  static _CategoryFormViewModel fromState(Store<AppState> store) {
    return _CategoryFormViewModel(
      onSave: (category, color) {
        store.dispatch(
          CreateCategory(
            Category(id: Uuid().v4(), name: category, color: color),
          ),
        );
      },
      usedColors: getUsedColors(store.state),
    );
  }
}
