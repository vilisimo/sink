import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/redux/reducers.dart';

import 'home.dart';

void main() {
  final Store store = Store<List<Entry>>(reduce, initialState: new List());

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
