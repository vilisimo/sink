import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/redux/reducers.dart';

import 'home.dart';

void main() {
  List<Entry> entries = [
    new Entry(
        cost: 26.3,
        date: DateTime.now(),
        category: "Food",
        description: "Essential food"),
    new Entry(
        cost: 9.05,
        date: DateTime.now().subtract(Duration(days: 3)),
        category: "Entertainment",
        description: "Cinema"),
  ];

  final Store store = Store<List<Entry>>(reduce, initialState: entries);

  runApp(Sink(store));
}

class Sink extends StatelessWidget {
  final Store<List<Entry>> store;

  Sink(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<List<Entry>>(
      store: store,
      child: MaterialApp(
        title: 'Sink',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
