import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/statistics/charts/chart_components.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';
import 'package:sink/ui/statistics/charts/year_breakdown.dart';

class YearExpenses extends StatelessWidget {
  final DateTime from;
  final DateTime to;

  YearExpenses({@required this.to})
      : this.from = DateTime(to.year - 1, to.month + 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(top: 0.0),
      child: StoreConnector(
          converter: _ViewModel.fromState,
          builder: (BuildContext context, _ViewModel vm) {
            return Card(
              child: StreamBuilder<QuerySnapshot>(
                stream: vm.database.snapshotBetween(from, to),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return PaddedCircularProgressIndicator();
                  }

                  List<Entry> entries = snapshot.data.documents
                      .where((ds) => ds['type'] != EntryType.INCOME.index)
                      .map((ds) => Entry.fromSnapshot(ds))
                      .toList();

                  List<DatedChartEntry> months = toChartEntries(
                    entries,
                    vm.resolveColor,
                  );

                  var same = months.isEmpty ||
                      months.first.date.year == months.last.date.year;

                  var label = same ? "${to.year}" : "${from.year} - ${to.year}";

                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: months.isEmpty
                        ? EmptyBreakdown(periodName: label)
                        : YearBreakdown(label: label, data: months),
                  );
                },
              ),
            );
          }),
    );
  }

  List<DatedChartEntry> toChartEntries(
    List<Entry> entries,
    Function(String) resolveCategory,
  ) {
    var grouped = SplayTreeMap<DateTime, double>();
    var topExpenses = SplayTreeMap<DateTime, Entry>();
    entries.forEach((entry) {
      final date = DateTime(entry.date.year, entry.date.month);
      grouped.update(
        date,
        (value) => value + entry.amount,
        ifAbsent: () => entry.amount,
      );
      topExpenses.update(
        date,
        (value) => value.amount >= entry.amount ? value : entry,
        ifAbsent: () => entry,
      );
    });

    return grouped.entries
        .map((e) => DatedChartEntry(
              date: e.key,
              label: monthsName(e.key),
              amount: e.value,
              color: resolveCategory(topExpenses[e.key].categoryId),
            ))
        .toList();
  }
}

class _ViewModel {
  final Function(String) resolveColor;
  final FirestoreDatabase database;

  _ViewModel({@required this.resolveColor, @required this.database});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      resolveColor: (id) => getCategoryColor(store.state, id),
      database: getRepository(store.state),
    );
  }
}
