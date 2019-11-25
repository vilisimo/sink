import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';

class CategoryMiddleware extends MiddlewareClass<AppState> {
  StreamSubscription<QuerySnapshot> categoriesListener;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is PreSignOut) {
      await categoriesListener?.cancel();
      store.dispatch(SignOut());
    } else if (action is RehydrateState) {
      final database = getRepository(store.state);
      categoriesListener = database.categories
          .orderBy('name', descending: false)
          .snapshots()
          .listen((qs) => reloadCategories(store, qs));
      store.dispatch(LoadFirstEntry());
    } else if (action is CreateCategory) {
      final database = getRepository(store.state);
      database.createCategory(action.category);
    }

    next(action);
  }

  void reloadCategories(Store<AppState> store, QuerySnapshot event) {
    Set<Category> categories = Set();
    event.documents.forEach((ds) => categories.add(Category.fromSnapshot(ds)));
    store.dispatch(ReloadCategories(categories));
    store.dispatch(ReloadColors(categories.map((c) => c.color).toSet()));
  }
}
