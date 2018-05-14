import 'package:flutter/material.dart';
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

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Container(
          child: new Text('Sink'),
          alignment: Alignment.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please enter a new expense'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add an expense',
        child: new Icon(Icons.add),
        onPressed: () => _enterExpense(context)
      ),
    );
  }

  void _enterExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) {
          return ExpenseForm();
        }
      ),
    );
  }
}
