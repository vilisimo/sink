import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/auth.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/drawer.dart';
import 'package:sink/ui/entries/add_entry_page.dart';
import 'package:sink/ui/entries/entries_page.dart';
import 'package:sink/ui/statistics/statistics_page.dart';

import '../main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        if (vm.authStatus == AuthenticationStatus.LOGGED_IN) {
          return HomePage();
        } else {
          return LoginScreen();
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

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      extendBody: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text('Sink'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          EntriesPage(),
          StatisticsPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add an expense',
        isExtended: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpensePage()),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.receipt)),
              Tab(icon: Icon(Icons.insert_chart)),
            ],
            controller: _tabController,
            labelColor: Colors.indigo,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
