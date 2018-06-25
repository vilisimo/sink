import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/exceptions/InvalidInput.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/date_picker.dart';
import 'package:sink/utils/validations.dart';

class AddExpenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function> (
      converter: (store) {
        return (entry) => store.dispatch(AddEntry(entry));
      },
      builder: (context, callback) {
        return ExpenseForm.save(callback);
      },
    );
  }
}

class EditExpenseScreen extends StatelessWidget {

  final Entry entry;
  final int position;

  EditExpenseScreen(this.entry, this.position);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function> (
      converter: (store) {
        return (entry) => store.dispatch(EditEntry(entry, position));
      },
      builder: (context, callback) {
        return ExpenseForm.edit(callback, entry);
      },
    );
  }
}


class ExpenseForm extends StatefulWidget {
  final Entry _expense;
  final Function onClick;

  ExpenseForm.save(this.onClick) : _expense = null;

  ExpenseForm.edit(this.onClick, this._expense);

  @override
  ExpenseFormState createState() {
    if (_expense != null) {
      return ExpenseFormState.edit(onClick, _expense);
    } else {
      return ExpenseFormState.save(onClick);
    }
  }
}

class ExpenseFormState extends State<ExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Function onClick;

  DateTime _initialDate = DateTime.now();
  double _cost;
  String _category;
  String _description;

  ExpenseFormState.save(this.onClick);

  ExpenseFormState.edit(this.onClick, Entry expense) {
    this._initialDate = expense.date;
    this._cost = expense.cost;
    this._category = expense.category;
    this._description = expense.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Entry')),
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                DatePicker(
                  labelText: 'From',
                  selectedDate: _initialDate,
                  onChanged: ((DateTime date) {
                    setState(() {
                      _initialDate = date;
                    });
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validatePrice(value),
                  onSaved: (value) => _cost = double.parse(value),
                  initialValue: _cost == null ? null : _cost.toString(),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Category"),
                  validator: (value) => _validateNotEmpty(value),
                  onSaved: (value) => _category = value,
                  initialValue: _category,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) => _validateNotEmpty(value),
                  onSaved: (value) => _description = value,
                  initialValue: _description,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            Entry entry = Entry(
                                cost: _cost,
                                date: _initialDate,
                                category: _category,
                                description: _description);

                            Navigator.pop(context);
                            onClick(entry);
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
