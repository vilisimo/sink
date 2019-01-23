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
      var categories = await loadCategories();
      store.dispatch(LoadCategories(categories));
    } else if (action is AddEntry) {
      FirestoreRepository.create(action.entry);
    } else if (action is DeleteEntry) {
      FirestoreRepository.delete(action.entry);
    } else if (action is UndoDelete) {
      Entry lastRemoved = getLastRemoved(store.state);
      FirestoreRepository.create(lastRemoved);
    } else if (action is EditEntry) {
      FirestoreRepository.create(action.entry);
    }

    next(action);
  }

  Future<List<String>> loadCategories() async {
    List<String> categories = [];

    await FirestoreRepository.getCategories().then((val) =>
        val.documents.forEach((ds) => categories.add(ds.data["name"])));

    return categories;
  }
}
