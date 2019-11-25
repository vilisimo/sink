import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';

class EntryMiddleware extends MiddlewareClass<AppState> {
  StreamSubscription<QuerySnapshot> entryListener;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is PreSignOut) {
      await entryListener?.cancel();
      store.dispatch(SignOut());
    } else if (action is LoadFirstEntry) {
      final db = getRepository(store.state);
      entryListener = db.getFirstEntry().listen((e) => loadMonths(store, e));
    } else if (action is AddEntry) {
      final database = getRepository(store.state);
      database.create(action.entry);
    } else if (action is DeleteEntry) {
      final database = getRepository(store.state);
      database.delete(action.entry);
    } else if (action is UndoDelete) {
      final database = getRepository(store.state);
      Entry lastRemoved = getLastRemoved(store.state);
      database.create(lastRemoved);
    } else if (action is EditEntry) {
      final database = getRepository(store.state);
      database.create(action.entry);
    }

    next(action);
  }

  void loadMonths(Store<AppState> store, QuerySnapshot event) {
    if (event.documents.isNotEmpty) {
      var firstEntry = Entry.fromSnapshot(event.documents.first).date;
      store.dispatch(LoadMonths(firstEntry, DateTime.now()));
    } else {
      store.dispatch(LoadMonths(DateTime.now(), DateTime.now()));
    }
  }
}
