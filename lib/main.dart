import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/middleware/middleware.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/reducers/reducers.dart';

import 'home.dart';

void main() {
  List<Entry> entries = [
    Entry(
        cost: 61.96,
        date: DateTime.now().subtract(Duration(days: 11)),
        category: "Car",
        description: "Gas to keep it going"),
    Entry(
        cost: 1.49,
        date: DateTime.now().subtract(Duration(days: 25)),
        category: "Lighter",
        description: "For dark nights full of terrors"),
    Entry(
        cost: 18.6,
        date: DateTime.now().subtract(Duration(days: 3)),
        category: "Clothes",
        description: "To hide the shame"),
    Entry(
        cost: 6.22,
        date: DateTime.now().subtract(Duration(days: 1)),
        category: "Books",
        description: "What kind of book costs less than a tenner"),
    Entry(
        cost: 6.18,
        date: DateTime.now().subtract(Duration(days: 4)),
        category: "Utilities",
        description: "Additional cable for those sticky situations"),
    Entry(
        cost: 26.3,
        date: DateTime.now(),
        category: "Food",
        description: "For thought"),
    Entry(
        cost: 9.05,
        date: DateTime.now().subtract(Duration(days: 3)),
        category: "Entertainment",
        description: "Movies to kill time"),
  ];

  entries.sort((a, b) {
    return a.date.isBefore(b.date) ? 1 : -1;
  });

  final Store store = Store<AppState>(
    reduce,
    distinct: true,
    initialState: AppState(entries),
    middleware: [SinkMiddleware()],
  );

  runApp(Sink(store));
}

class Sink extends StatelessWidget {
  final Store<AppState> store;

  Sink(this.store);

  @override
  Widget build(BuildContext context) {
    store.dispatch(new InitApp());

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Sink',
        theme: ThemeData(
          backgroundColor: Colors.purple,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
