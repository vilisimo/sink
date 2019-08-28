import 'package:redux/redux.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';

class SinkMiddleware extends MiddlewareClass<AppState> {
  final Authentication auth = FirebaseEmailAuthentication();

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RetrieveUser) {
      next(action);
      auth.getCurrentUser().then((user) {
        store.dispatch(SetUserId(user?.uid.toString()));
        store.dispatch(RehydrateState());
      });
    } else if (action is SignOut) {
      await auth.signOut();
      store.dispatch(SetUserId(null));
    } else if (action is RehydrateState) {
      var userId = getUserId(store.state); // TODO: use to get user's data
      FirestoreRepository.categories
          .orderBy('name', descending: false)
          .snapshots()
          .listen((qs) {
        Set<Category> categories = Set();
        qs.documents.forEach((ds) => categories.add(Category.fromSnapshot(ds)));
        store.dispatch(ReloadCategories(categories));
        store.dispatch(ReloadColors(categories.map((c) => c.color).toSet()));
      });
      store.dispatch(LoadFirstEntry());
    } else if (action is LoadFirstEntry) {
      FirestoreRepository.getFirstEntry().listen((event) {
        var firstEntry = Entry.fromSnapshot(event.documents.first).date;
        store.dispatch(LoadMonths(firstEntry, DateTime.now()));
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
}
