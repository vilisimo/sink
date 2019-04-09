import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';

class MonthExpenses extends StatelessWidget {
  final DateTime from; // TODO: calculate month's start
  final DateTime to;

  MonthExpenses({@required this.from, @required this.to});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return Card(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreRepository.snapshotBetween(from, to),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return PaddedCircularProgressIndicator();
              }

              List<Entry> entries = snapshot.data.documents
                  .map((ds) => Entry.fromSnapshot(ds))
                  .toList();

              Map<String, double> months = group(entries);
              List<Widget> categoryExpenditures = months.entries
                  .map((MapEntry<String, double> entry) =>
                      Text("${vm.resolveId(entry.key)}: ${entry.value}"))
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: categoryExpenditures,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// TODO: explicit class for category's amount
Map<String, double> group(List<Entry> entries) {
  var categories = Map<String, double>();
  entries.forEach((entry) => categories.update(
      entry.categoryId, (value) => value + entry.amount,
      ifAbsent: () => entry.amount));
  categories.forEach((month, value) => print("$month: $value"));

  return categories;
}

@immutable
class _ViewModel {
  final Function(String) resolveId;

  _ViewModel({@required this.resolveId});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(resolveId: (id) => getCategory(store.state, id).name);
  }
}
