import 'package:flutter/material.dart';
import 'package:sink/ui/drawer.dart';
import 'package:sink/ui/entries/add_entry_page.dart';
import 'package:sink/ui/entries/entries_page.dart';
import 'package:sink/ui/statistics/statistics_page.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
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
        onPressed: () => Navigator.pushNamed(context, AddExpensePage.route),
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
