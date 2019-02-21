import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/color_gird.dart';
import 'package:uuid/uuid.dart';

class CategoryForm extends StatefulWidget {
  @override
  CategoryFormState createState() {
    return new CategoryFormState();
  }
}

class CategoryFormState extends State<CategoryForm> {
  String category;

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: _CategoryFormViewModel.fromState,
      builder: (BuildContext context, _CategoryFormViewModel vm) {
        List<Color> colors = List.from(Colors.primaries);
        colors.addAll(Colors.accents);
        colors.removeWhere((color) => vm.usedColors
            .contains(Color.fromRGBO(color.red, color.green, color.blue, 1.0)));

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text('New Category'),
            actions: <Widget>[
              IconButton(
                iconSize: 28.0,
                icon: Icon(Icons.check),
                onPressed: () {
                  vm.onSave(category);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  //TODO: create a custom component with clear icon on the right
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Category name",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  maxLength: 24,
                ),
              ),
              ColorGrid(colors),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryFormViewModel {
  final Function(String) onSave;
  final Set<Color> usedColors;

  _CategoryFormViewModel({@required this.onSave, @required this.usedColors});

  static _CategoryFormViewModel fromState(Store<AppState> store) {
    return _CategoryFormViewModel(
      onSave: (category) {
        store.dispatch(CreateCategory(Category(
          id: Uuid().v4(),
          name: category,
          // TODO: introduce color picker? Should show available and used
          color: Colors.grey,
        )));
      },
      usedColors: getUsedColors(store.state),
    );
  }
}
