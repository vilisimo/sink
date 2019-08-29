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
        store.dispatch(SetUserId(user == null ? null : user.uid.toString()));
      }).then((value) => store.dispatch(RehydrateState()));
    } else if (action is SignIn) {
      auth
          .signIn(action.email, action.password)
          .then((userId) => store.dispatch(SetUserId(userId)))
          .then((value) => store.dispatch(RehydrateState()))
          .catchError((error) => print('Error: $error')); // TODO: show error
    } else if (action is SignOut) {
      auth.signOut().then((value) => store.dispatch(SetUserId(null)));
    } else if (action is Register) {
      store.dispatch(StartRegistration());
      auth
          .signUp(action.email, action.password)
          .then((value) => store.dispatch(SendVerificationEmail()))
          .then((value) => store.dispatch(ReportRegistrationSuccess()))
          .catchError((e) => store.dispatch(ReportAuthenticationError(e.code)));
    } else if (action is SendVerificationEmail) {
      auth.sendEmailVerification();
    } else if (action is RehydrateState) {
      final userId = getUserId(store.state); // TODO: use to get user's data
      print('User id: $userId');
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
