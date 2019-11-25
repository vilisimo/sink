import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/main.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/home.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final Authentication auth;

  AuthMiddleware(this.navigatorKey) : this.auth = FirebaseEmailAuthentication();

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
      navigatorKey.currentState.pushReplacementNamed(InitialPage.route);
      // HACK: I could not find a way to ensure that all streams to Firestore
      // are closed before user is signed out. It seems that after replacing a
      // route, the old one is still active for some time and is still receiving
      // events from Firestore, which result in permission denied exceptions.
      // Hence, we need to wait a little bit until old widget is disposed of.
      await Future.delayed(Duration(milliseconds: 1000))
          .then((_) => store.dispatch(SetUserDetails(id: "", email: "")))
          .then((_) => auth.signOut());
    } else if (action is Register) {
      store.dispatch(StartRegistration());
      auth
          .signUp(action.email, action.password)
          .then((value) => store.dispatch(SendVerificationEmail()))
          .then((value) => store.dispatch(ReportRegistrationSuccess()))
          .catchError((e) => store.dispatch(ReportAuthenticationError(e.code)));
    } else if (action is SendVerificationEmail) {
      auth.sendEmailVerification();
    }

    next(action);
  }

  void attemptUserRetrieval(Store<AppState> store, FirebaseUser user) {
    if (user != null && user.isEmailVerified) {
      final userId = user.uid.toString();
      store.dispatch(SetUserDetails(id: userId, email: user.email));
      store.dispatch(InitializeDatabase(user.uid));
      store.dispatch(RehydrateState());
      navigatorKey.currentState.popAndPushNamed(HomeScreen.route);
    } else {
      store.dispatch(SetUserDetails(id: "", email: ""));
      navigatorKey.currentState.popAndPushNamed(InitialPage.route);
    }
  }

  void attemptSignIn(Store<AppState> store, FirebaseUser user) {
    if (user.isEmailVerified) {
      store.dispatch(SetUserDetails(id: user.uid, email: user.email));
      store.dispatch(InitializeDatabase(user.uid));
      store.dispatch(ReportSignInSuccess());
      store.dispatch(RehydrateState());
      navigatorKey.currentState.popAndPushNamed(HomeScreen.route);
    } else {
      store.dispatch(SignOut());
      store.dispatch(ReportAuthenticationError("Email is not verified."));
    }
  }
}
