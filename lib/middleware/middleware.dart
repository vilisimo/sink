import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/models/state.dart';

class SinkMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is InitApp) {
      print('Application initialized, retrieving data...');

      CollectionReference entries = Firestore.instance.collection('entry');
      Stream<QuerySnapshot> snapshots = entries.snapshots();
      snapshots.listen((onData) =>
          print("Test data: " + onData.documents[0]['description']));
    }
  }
}
