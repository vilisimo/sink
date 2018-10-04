import 'package:redux/redux.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/selectors/selectors.dart';

class SinkMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is AddEntry) {
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
}
