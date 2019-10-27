import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';

class SinkMiddleware extends MiddlewareClass<AppState> {
  final Authentication auth = FirebaseEmailAuthentication();

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RetrieveUser) {
      auth.getCurrentUser().then((user) => attemptUserRetrieval(store, user));
    } else if (action is SignIn) {
      auth
          .signIn(action.email, action.password)
          .then((user) => attemptSignIn(store, user))
          .catchError((e) => store.dispatch(ReportAuthenticationError(e.code)));
    } else if (action is SignOut) {
      auth
          .signOut()
          .then((value) => store.dispatch(SetUserDetails(id: "", email: "")));
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
      final database = getRepository(store.state);
      database.categories
          .orderBy('name', descending: false)
          .snapshots()
          .listen((qs) => reloadCategories(store, qs));
      store.dispatch(LoadFirstEntry());
    } else if (action is LoadFirstEntry) {
      final database = getRepository(store.state);
      database.getFirstEntry().listen((event) => loadMonths(store, event));
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
    } else if (action is CreateCategory) {
      final database = getRepository(store.state);
      database.createCategory(action.category);
    }

    next(action);
  }

  void attemptUserRetrieval(Store<AppState> store, FirebaseUser user) {
    if (user != null && user.isEmailVerified) {
      final userId = user.uid.toString();
      store.dispatch(SetUserDetails(id: userId, email: user.email));
      store.dispatch(InitializeDatabase(user.uid));
      store.dispatch(RehydrateState());
    } else {
      store.dispatch(SetUserDetails(id: "", email: ""));
    }
  }

  void attemptSignIn(Store<AppState> store, FirebaseUser user) {
    if (user.isEmailVerified) {
      store.dispatch(SetUserDetails(id: user.uid, email: user.email));
      store.dispatch(InitializeDatabase(user.uid));
      store.dispatch(ReportSignInSuccess());
      store.dispatch(RehydrateState());
    } else {
      store.dispatch(SignOut());
      store.dispatch(ReportAuthenticationError("Email is not verified."));
    }
  }

  void reloadCategories(Store<AppState> store, QuerySnapshot event) {
    Set<Category> categories = Set();
    event.documents.forEach((ds) => categories.add(Category.fromSnapshot(ds)));
    store.dispatch(ReloadCategories(categories));
    store.dispatch(ReloadColors(categories.map((c) => c.color).toSet()));
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
