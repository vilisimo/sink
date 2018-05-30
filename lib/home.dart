import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/ui/expense_form.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Entry> entries = List();
  ScrollController listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text('Sink'),
          alignment: Alignment.center,
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          controller: listViewController,
          itemCount: entries.length,
          itemBuilder: (buildContext, index) {
            return Dismissible(
              key: ObjectKey(entries[index]),
              direction: DismissDirection.horizontal,
              onDismissed: (DismissDirection direction) {
                setState(() {
                  entries.removeAt(index);
                });
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        DateFormat.yMMMMEEEEd().format(entries[index].date),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    ListTile(
                      title: Text(entries[index].category.toString()),
                      subtitle: Text(entries[index].description.toString()),
                      trailing: Text(
                        "${entries[index].cost} €",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onTap: () => _editExpense(entries[index]),
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add an expense',
          child: Icon(Icons.add),
          onPressed: () => _enterExpense()),
    );
  }

  Future _editExpense(Entry expense) async {
    Entry editedEntry = await Navigator.of(context).push(
          MaterialPageRoute<Entry>(
              fullscreenDialog: true,
              builder: (context) {
                return ExpenseForm.edit(expense);
              }),
        );

    if (editedEntry != null) {
      setState(() => entries[entries.indexOf(expense)] = editedEntry);
    }
  }

  Future _enterExpense() async {
    Entry newEntry = await Navigator.of(context).push(
          MaterialPageRoute<Entry>(
              fullscreenDialog: true,
              builder: (context) {
                return ExpenseForm.save();
              }),
        );

    if (newEntry != null) {
      setState(() {
        entries.add(newEntry);
        listViewController.animateTo(
          listViewController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.ease,
        );
      });
    }
  }
}
