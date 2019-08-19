import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationStatus {
  LOADING,
  ANONYMOUS,
  LOGGED_IN,
}

abstract class Authentication {
  Future<String> signUp(String email, String password);

  Future<String> signIn(String email, String password);

  Future<void> signOut();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<FirebaseUser> getCurrentUser();
}

class FirebaseEmailAuthentication implements Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(String email, String password) async {
    var result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = result.user;

    return user.uid;
  }

  Future<String> signIn(String email, String password) async {
    var result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = result.user;

    return user.uid;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    var user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    var user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  Future<FirebaseUser> getCurrentUser() async {
    var user = await _auth.currentUser();
    return user;
  }
}
