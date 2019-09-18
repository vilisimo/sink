import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:sink/common/enums.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/common/date_picker.dart';
import 'package:sink/ui/common/number_input.dart';
import 'package:sink/ui/common/text_input.dart';
import 'package:sink/ui/forms/category_grid.dart';

class EntryForm extends StatefulWidget {
  final Function(Entry) onSave;
  final Entry entry;

  EntryForm({this.onSave, this.entry});

  @override
  EntryFormState createState() {
    return EntryFormState(entry: this.entry);
  }
}

class EntryFormState extends State<EntryForm> {
  static const inputPadding = EdgeInsets.all(16.0);
  static const cardPadding = EdgeInsets.only(left: 16.0, right: 16.0);
  static const datePadding = EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0);

  final Entry entry;

  static List<String> options = toCapitalizedStringList(EntryType.values);

  String _type;
  String _selectedCategoryId;
  DateTime _date;
  double _amount;
  String _description;

  EntryFormState({this.entry})
      : _date = entry.date ?? DateTime.now(),
        _selectedCategoryId = entry.categoryId,
        _amount = entry.amount,
        _description = entry.description,
        _type = entry.type == null
            ? toCapitalizedString(EntryType.EXPENSE)
            : toCapitalizedString(entry.type);

  void handlePressed(BuildContext context) {
    Entry newEntry = Entry(
      id: entry.id,
      date: _date,
      amount: _amount,
      categoryId: _selectedCategoryId,
      type: toEntryType(_type),
      description: _description,
    );
    widget.onSave(newEntry);
    Navigator.pop(context);
  }

  bool isSaveable() {
    return _amount != null && !isBlank(_selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: buildThemedDropdown(context),
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
            padding: datePadding,
            child: Card(
              child: DatePicker(
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
                    this._amount = value;
                  });
                },
                value: _amount,
                hintText: '0.0',
                style: Theme.of(context).textTheme.body1,
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
                    this._description = value;
                  });
                },
                value: _description,
                hintText: 'Description',
                style: Theme.of(context).textTheme.body1,
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
                  type: matchingCategoryType(),
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

  Theme buildThemedDropdown(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).backgroundColor,
        brightness: Brightness.dark,
      ),
      child: buildDropdown(context),
    );
  }

  DropdownButtonHideUnderline buildDropdown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        value: _type,
        items: options.map((type) => buildDropdownItem(type, context)).toList(),
        onChanged: (newType) {
          setState(() {
            _selectedCategoryId = _type == newType ? _selectedCategoryId : null;
            _type = newType;
          });
        },
      ),
    );
  }

  DropdownMenuItem<String> buildDropdownItem(String txt, BuildContext context) {
    return DropdownMenuItem(
      child: Text(
        txt,
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
      ),
      value: txt,
    );
  }

  CategoryType matchingCategoryType() {
    return toEntryType(_type) == EntryType.EXPENSE
        ? CategoryType.EXPENSE
        : CategoryType.INCOME;
  }
}
