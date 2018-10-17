import 'package:flutter/material.dart';
import 'package:sink/exceptions/InvalidInput.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/presentation/date_picker.dart';
import 'package:sink/utils/validations.dart';

class ExpenseForm extends StatefulWidget {
  final Function(Entry) onSave;
  final Entry entry;

  ExpenseForm({this.onSave, this.entry});

  @override
  ExpenseFormState createState() {
    return ExpenseFormState(onSave: this.onSave, entry: this.entry);
  }
}

class ExpenseFormState extends State {
  final _formKey = GlobalKey<FormState>();
  final _category = GlobalKey<FormFieldState<String>>();
  final _description = GlobalKey<FormFieldState<String>>();
  final _cost = GlobalKey<FormFieldState<String>>();

  final Function(Entry) onSave;
  final Entry entry;

  DateTime _date;

  ExpenseFormState({@required this.onSave, this.entry})
      : _date = entry.date ?? DateTime.now();

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
                    category: _category.currentState.value,
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
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter a price",
                    prefixIcon: Icon(Icons.attach_money),
                    border: InputBorder.none,
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
                  key: _category,
                  initialValue: entry.category,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter a category",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  validator: (value) => _validateNotEmpty(value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                child: TextFormField(
                  key: _description,
                  initialValue: entry.description,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
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
    try {
      nonNegative(value);
      return null;
    } on InvalidInput catch (e) {
      return e.cause;
    }
  }
}
