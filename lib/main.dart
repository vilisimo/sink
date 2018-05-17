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
          return new Column(
            children: <Widget>[
              ListTile(
                leading: Text(DateFormat.MMMEd().format(entries[index].date)),
                title: Text(entries[index].category.toString()),
                subtitle: Text(entries[index].category.toString()),
                trailing: Text(entries[index].cost.toString()),
              )
            ],
          );
        }),
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
