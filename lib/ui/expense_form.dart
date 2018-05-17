import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sink/domain/expense.dart';
import 'package:sink/utils/validations.dart';
import 'package:sink/exceptions/InvalidInput.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  @override
  ExpenseFormState createState() {
    return ExpenseFormState();
  }
}

class ExpenseFormState extends State<ExpenseForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _initialDate = DateTime.now();

  String _description;
  double _cost;
  String _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter a record')),
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter a price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validatePrice(value),
                  onSaved: (value) => _cost = double.parse(value),
                ),
                _textFormField("Add a note", (value) => _description = value),
                _textFormField(
                    "Enter a category", (value) => _category = value),
                _DateTimePicker(
                  labelText: 'From',
                  selectedDate: _initialDate,
                  selectDate: ((DateTime date) {
                    setState(() {
                      _initialDate = date;
                    });
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.of(context).pop(Expense(
                            cost: _cost,
                            date: _initialDate,
                            category: _category,
                            description: _description
                        ));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TextFormField _textFormField(String label, Function onSave) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) => _validateNotEmpty(value),
      onSaved: onSave,
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

class _DateTimePicker extends StatelessWidget {

  static const _YEAR = 365;

  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: _YEAR * 10)),
        lastDate: DateTime.now().add(Duration(days: _YEAR * 10)),
    );

    if (picked != null && picked != selectedDate) {
      selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () { _selectDate(context); },
            child: InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(DateFormat.yMMMd().format(selectedDate))
                ],
              ),
            )
          )
        )
      ],
    );
  }}
