import 'package:flutter/material.dart';
import 'package:sink/common/exceptions.dart';
import 'package:sink/common/validations.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/common/date_picker.dart';
import 'package:sink/ui/forms/category_grid.dart';

class ExpenseForm extends StatefulWidget {
  final Function(Entry) onSave;
  final Entry entry;

  ExpenseForm({this.onSave, this.entry});

  @override
  ExpenseFormState createState() {
    return ExpenseFormState(
      onSave: this.onSave,
      entry: this.entry,
    );
  }
}

class ExpenseFormState extends State {
  final _formKey = GlobalKey<FormState>();
  final _description = GlobalKey<FormFieldState<String>>();
  final _cost = GlobalKey<FormFieldState<String>>();

  final Function(Entry) onSave;
  final Entry entry;
  String _selectedCategory;

  DateTime _date;

  ExpenseFormState({
    @required this.onSave,
    this.entry,
  })  : _date = entry.date ?? DateTime.now(),
        _selectedCategory = entry.category;

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
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Entry newEntry = Entry(
                    date: _date,
                    cost: double.parse(_cost.currentState.value),
                    category: _selectedCategory,
                    description: _description.currentState.value,
                    id: entry.id);
                onSave(newEntry);

                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                child: TextFormField(
                  key: _cost,
                  initialValue:
                      entry.cost == null ? null : entry.cost.toString(),
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter a price",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validatePrice(value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                child: TextFormField(
                  key: _description,
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: entry.description,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Provide a description",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  validator: (value) => _validateNotEmpty(value),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  child: CategoryGrid(
                    selected: _selectedCategory,
                    onTap: (selected) {
                      setState(() {
                        _selectedCategory = selected;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validateNotEmpty(String value) {
    try {
      notEmpty(value);
      return null;
    } on InvalidInput catch (e) {
      return e.cause;
    }
  }

  String _validatePrice(String value) {
    //TODO: validate number - stateful component?
    try {
      nonNegative(value);
      return null;
    } on InvalidInput catch (e) {
      return e.cause;
    }
  }
}
