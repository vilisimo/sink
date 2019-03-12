import 'package:flutter/material.dart';
import 'package:sink/common/checks.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/common/date_picker.dart';
import 'package:sink/ui/common/number_input.dart';
import 'package:sink/ui/common/text_input.dart';
import 'package:sink/ui/forms/category_grid.dart';

class ExpenseForm extends StatefulWidget {
  final Function(Entry) onSave;
  final Entry entry;

  ExpenseForm({this.onSave, this.entry});

  @override
  ExpenseFormState createState() {
    return ExpenseFormState(entry: this.entry);
  }
}

class ExpenseFormState extends State<ExpenseForm> {
  static const style = TextStyle(fontSize: 16.0, color: Colors.black);
  static const inputPadding = EdgeInsets.all(16.0);
  static const cardPadding = EdgeInsets.only(left: 16.0, right: 16.0);

  final Entry entry;

  String _selectedCategoryId;
  DateTime _date;
  double _cost;
  String desc;

  ExpenseFormState({this.entry})
      : _date = entry.date ?? DateTime.now(),
        _selectedCategoryId = entry.categoryId,
        _cost = entry.cost,
        desc = entry.description;

  void handlePressed(BuildContext context) {
    Entry newEntry = Entry(
      id: entry.id,
      date: _date,
      cost: _cost,
      categoryId: _selectedCategoryId,
      // TODO: should depend on the type of form
      type: EntryType.EXPENSE,
      description: desc,
    );
    widget.onSave(newEntry);
    Navigator.pop(context);
  }

  bool isSaveable() {
    return _cost != null && !isEmpty(_selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('New Entry'),
        actions: <Widget>[
          IconButton(
            iconSize: 28.0,
            icon: Icon(Icons.save),
            onPressed: isSaveable() ? () => handlePressed(context) : null,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Card(
              child: DatePicker(
                labelText: 'From',
                selectedDate: _date,
                onChanged: ((DateTime date) {
                  setState(() {
                    _date = date;
                  });
                }),
              ),
            ),
          ),
          Padding(
            padding: cardPadding,
            child: Card(
              child: ClearableNumberInput(
                onChange: (value) {
                  setState(() {
                    this._cost = value;
                  });
                },
                value: _cost,
                hintText: '0.0',
                style: style,
                contentPadding: inputPadding,
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: cardPadding,
            child: Card(
              child: ClearableTextInput(
                onChange: (value) {
                  setState(() {
                    this.desc = value;
                  });
                },
                value: desc,
                hintText: 'Description',
                style: style,
                maxLines: 3,
                contentPadding: inputPadding,
                border: InputBorder.none,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: cardPadding,
              child: Card(
                child: CategoryGrid(
                  selected: _selectedCategoryId,
                  onTap: (selected) {
                    setState(() {
                      _selectedCategoryId = selected;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
