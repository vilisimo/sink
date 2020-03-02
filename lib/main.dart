import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/middlewares/auth.dart';
import 'package:sink/redux/middlewares/categories.dart';
import 'package:sink/redux/middlewares/entries.dart';
import 'package:sink/redux/reducers.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/theme.dart';
import 'package:sink/ui/categories/category_list.dart';
import 'package:sink/ui/common/buttons.dart';
import 'package:sink/ui/entries/add_entry_page.dart';
import 'package:sink/ui/entries/edit_entry_page.dart';
import 'package:sink/ui/forms/registration.dart';
import 'package:sink/ui/forms/signin.dart';
import 'package:sink/ui/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final navigatorKey = GlobalKey<NavigatorState>();
  final Store store = Store<AppState>(
    reduce,
    distinct: true,
    initialState: AppState(areCategoriesLoading: true),
    middleware: [
      CategoryMiddleware(),
      EntryMiddleware(),
      AuthMiddleware(navigatorKey),
    ],
  );
  store.dispatch(RetrieveUser());

  runApp(Sink(navigatorKey, store));
}

class Sink extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> store;

  Sink(this.navigatorKey, this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Sink',
        theme: appTheme,
        navigatorKey: navigatorKey,
        routes: {
          InitialPage.route: (context) => InitialPage(),
          RegistrationForm.route: (context) => RegistrationForm(),
          CategoryList.route: (context) => CategoryList(),
          HomeScreen.route: (context) => HomeScreen(),
          AddExpensePage.route: (context) => AddExpensePage(),
          EditExpensePage.route: (context) => EditExpensePage(),
        },
        initialRoute: InitialPage.route,
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  static const route = '/';

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
                onPressed: () => Navigator.pushNamed(
                  context,
                  RegistrationForm.route,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
