import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/middleware.dart';
import 'package:sink/redux/reducers.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';
import 'package:sink/ui/categories/category_list.dart';
import 'package:sink/ui/common/buttons.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/forms/registration.dart';
import 'package:sink/ui/forms/signin.dart';
import 'package:sink/ui/home.dart';

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  final Store store = Store<AppState>(
    reduce,
    distinct: true,
    initialState: AppState(areCategoriesLoading: true),
    middleware: [SinkMiddleware(navigatorKey)],
  );

  runApp(Sink(navigatorKey, store));
}

class Sink extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> store;

  Sink(this.navigatorKey, this.store);

  @override
  Widget build(BuildContext context) {
    store.dispatch(RetrieveUser());

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Sink',
        theme: ThemeData(
          backgroundColor: Colors.purple,
          iconTheme: IconThemeData(
            size: ICON_SIZE,
          ),
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 16.0),
            body2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
        ),
        navigatorKey: navigatorKey,
        routes: {
          '/login': (context) => LoginScreen(),
          '/categories': (context) => CategoryList(),
        },
        home: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  bool _isLoading(AuthenticationStatus status) {
    return status == AuthenticationStatus.LOADING;
  }

  bool _isAnonymous(AuthenticationStatus status) {
    return status == AuthenticationStatus.ANONYMOUS;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        if (_isLoading(vm.authStatus)) {
          return LoadingPage();
        } else if (_isAnonymous(vm.authStatus)) {
          return InitialPage();
        } else {
          return HomeScreen();
        }
      },
    );
  }
}

class _ViewModel {
  final AuthenticationStatus authStatus;

  _ViewModel({@required this.authStatus});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(authStatus: getAuthStatus(store.state));
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PaddedCircularProgressIndicator(),
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SignInForm(),
              RoundedButton(
                text: 'Register',
                buttonColor: Colors.blue,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
