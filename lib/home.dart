import 'dart:async';

import 'package:collection/collection.dart';
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

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          child: Text('Sink'),
          alignment: Alignment.center,
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          padding: EdgeInsets.all(8.0),
          controller: listViewController,
          itemCount: entries.length,
          itemBuilder: (buildContext, index) {
            return Dismissible(
              key: ObjectKey(entries[index]),
              background: Card(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      // TODO: figure out how to show icon on left/right depending on direction
                      child: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection direction) {
                var item = entries[index];
                setState(() {
                  entries.removeAt(index);
                });

                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Entry removed'),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () => handleUndo(item, index),
                  ),
                ));
              },
              child: Card(
                child: InkWell(
                  onTap: () => _editExpense(entries[index]),
                  enableFeedback: true,
                  child: Container(
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 6.0
                          ),
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  entries[index].category.toString(),
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        entries[index].description.toString(),
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        DateFormat.yMMMMEEEEd().format(entries[index].date),
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  ],
                                ),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "${entries[index].cost} €",
                                    style: TextStyle(fontSize: 20.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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

  void handleUndo(Entry entry, int index) {
    final int entryIndex = entries.length >= index ? index : entries.length;

    setState(() {
      entries.insert(entryIndex, entry);
    });
  }
}
