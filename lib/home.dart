import 'package:flutter/material.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/containers/entries_page.dart';
import 'package:sink/ui/presentation/expense_form.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Entry> entries = List();

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
      body: EntryListPage(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add an expense',
        child: Icon(Icons.add),
        onPressed: () => showDialog(
            context: context, builder: (context) => AddExpenseScreen()),
      ),
    );
  }
}
