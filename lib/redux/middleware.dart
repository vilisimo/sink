import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';

class SinkMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is InitState) {
      FirestoreRepository.categories
          .orderBy('name', descending: false)
          .snapshots()
          .listen((qs) {
        Set<String> categories = Set();
        qs.documents.forEach((ds) => categories.add(ds.data["name"]));
        store.dispatch(LoadCategories(categories));
      });
    } else if (action is AddEntry) {
      FirestoreRepository.create(action.entry);
    } else if (action is DeleteEntry) {
      FirestoreRepository.delete(action.entry);
    } else if (action is UndoDelete) {
      Entry lastRemoved = getLastRemoved(store.state);
      FirestoreRepository.create(lastRemoved);
    } else if (action is EditEntry) {
      FirestoreRepository.create(action.entry);
    } else if (action is CreateCategory) {
      FirestoreRepository.createCategory(action.category);
    }

    next(action);
  }

  Future<Set<String>> loadCategories() async {
    Set<String> categories = Set();

    await FirestoreRepository.getCategories().then((val) =>
        val.documents.forEach((ds) => categories.add(ds.data["name"])));

    return categories;
  }
}
