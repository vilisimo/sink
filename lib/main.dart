import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sink/domain/expense.dart';
import 'package:sink/ui/expense_form.dart';

void main() => runApp(Sink());

class Sink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  List<Expense> entries = List();
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
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(entries[index].date),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text(entries[index].category.toString()),
                  subtitle: Text(entries[index].category.toString()),
                  trailing: Text(
                    "${entries[index].cost} €",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              new ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: const Text('EDIT'),
                      onPressed: () {
                        // TODO: add edit
                      },
                    ),
                    new FlatButton(
                      child: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          entries.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add an expense',
          child: Icon(Icons.add),
          onPressed: () => _enterExpense()),
    );
  }

  Future _enterExpense() async {
    Expense newEntry = await Navigator.of(context).push(
      MaterialPageRoute<Expense>(
          fullscreenDialog: true,
          builder: (context) {
            return ExpenseForm();
          }),
    );

    if (newEntry != null) {
      setState(() {
        entries.add(newEntry);
        listViewController.animateTo(
            entries.length * 50.0,
            duration: Duration(microseconds: 5),
            curve: new ElasticInCurve(0.01),
        );
      });
    }
  }
}
