import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/expenditure.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';

//TODO: also show in bar chart?
class MonthExpenses extends StatelessWidget {
  final DateTime from; // TODO: calculate month's start
  final DateTime to;

  MonthExpenses({@required this.from, @required this.to});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        //TODO: add padding
        return Card(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreRepository.snapshotBetween(from, to),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return PaddedCircularProgressIndicator();
              }

              List<Entry> entries = snapshot.data.documents
                  .map((ds) => Entry.fromSnapshot(ds))
                  .where((entry) => entry.type != EntryType.INCOME)
                  .toList();

              var expenditures = groupExpenditures(entries, vm.toCategory);

              List<Widget> categoryExpenditures = expenditures
                  .map(
                    (e) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                //TODO: largest expense = 100%; others = 100 * x (given x < 1.0);
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.4, //TODO: adjust bar width for category amount
                                  height: 20.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9.0),
                                      ),
                                      color: e.bucket.color,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "${e.bucket.name}: ${e.amount}",
                              )
                            ],
                          ),
                        ),
                  )
                  .toList();

              return Column(
                children: categoryExpenditures,
              );
            },
          ),
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  final Function(String) toCategory;

  _ViewModel({@required this.toCategory});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(toCategory: (id) => getCategory(store.state, id));
  }
}

Iterable<Expenditure<Category>> groupExpenditures(
    List<Entry> entries, Function(String) toCategory) {
  var categories = Map<Category, double>();
  entries.forEach(
    (entry) => categories.update(
        toCategory(entry.categoryId), (value) => value + entry.amount,
        ifAbsent: () => entry.amount),
  );

  var result = categories.entries
      .map((entry) => Expenditure(bucket: entry.key, amount: entry.value))
      .toList();
  result.sort();

  return result.reversed;
}
