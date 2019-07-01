import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/theme/palette.dart' as Palette;
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/statistics/charts/breakdown_chart.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

class MonthExpenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _MonthExpensesViewModel>(
      converter: _MonthExpensesViewModel.fromState,
      builder: (context, vm) {
        return Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0.0),
          child: Card(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreRepository.snapshotBetween(vm.start, vm.end),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return PaddedCircularProgressIndicator();
                }

                List<Entry> entries = snapshot.data.documents
                    .where((ds) => ds['type'] != EntryType.INCOME.index)
                    .map((ds) => Entry.fromSnapshot(ds))
                    .toList();

                var label = monthsName(vm.end);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: entries.isEmpty
                      ? EmptyMonthBreakdown()
                      : SortedBreakdown(
                          month: label,
                          data: toBars(entries, vm.toCategory),
                          ascending: false,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

@immutable
class _MonthExpensesViewModel {
  final Function(String) toCategory;
  final DateTime start;
  final DateTime end;

  _MonthExpensesViewModel({
    @required this.toCategory,
    @required this.start,
    @required this.end,
  });

  static _MonthExpensesViewModel fromState(Store<AppState> store) {
    return _MonthExpensesViewModel(
      toCategory: (id) => getCategory(store.state, id),
      start: getStatisticsMonthStart(store.state),
      end: getStatisticsMonthEnd(store.state),
    );
  }
}

List<ChartEntry> toBars(List<Entry> entries, Function(String) toCategory) {
  var categories = Map<Category, double>();
  entries.forEach(
    (entry) => categories.update(
        toCategory(entry.categoryId), (value) => value + entry.amount,
        ifAbsent: () => entry.amount),
  );

  return categories.entries
      .map((entry) => ChartEntry(
            label: entry.key.name,
            amount: entry.value,
            color: entry.key.color,
          ))
      .toList();
}

class EmptyMonthBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _EmptyMonthBreakdownViewModel>(
        converter: _EmptyMonthBreakdownViewModel.fromState,
        builder: (context, vm) {
          return Container(
            alignment: Alignment.center,
            child: Column(children: [
              MonthSlider(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text('${vm.selectedMonth} has no entries yet'),
              )
            ]),
          );
        });
  }
}

class _EmptyMonthBreakdownViewModel {
  final String selectedMonth;

  _EmptyMonthBreakdownViewModel({
    @required this.selectedMonth,
  });

  static _EmptyMonthBreakdownViewModel fromState(Store<AppState> store) {
    return _EmptyMonthBreakdownViewModel(
      selectedMonth: monthsName(getSelectedMonth(store.state).element),
    );
  }
}

class MonthSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _MonthSliderViewModel>(
      converter: _MonthSliderViewModel.fromState,
      builder: (context, vm) {
        var selectedMonth = vm.selectedMonth;
        var nextMonth = selectedMonth.previousEntry();
        var prevMonth = selectedMonth.nextEntry();
        return Row(
          children: <Widget>[
            prevMonth == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.transparent,
                      size: 24,
                    ),
                  )
                : InkWell(
                    enableFeedback: prevMonth != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color:
                            prevMonth == null ? Palette.disabled : Colors.black,
                        size: 24,
                      ),
                    ),
                    onTap: () =>
                        prevMonth != null ? vm.selectMonth(prevMonth) : null,
                  ),
            Expanded(
              child: Center(
                child: Text(
                  "${monthsName(selectedMonth.element)} "
                  "(${selectedMonth.element.year})",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            nextMonth == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.transparent,
                      size: 24,
                    ),
                  )
                : InkWell(
                    enableFeedback: nextMonth != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color:
                            nextMonth == null ? Palette.disabled : Colors.black,
                        size: 24,
                      ),
                    ),
                    onTap: () =>
                        nextMonth != null ? vm.selectMonth(nextMonth) : null,
                  ),
          ],
        );
      },
    );
  }
}

class _MonthSliderViewModel {
  final Function(DoubleLinkedQueueEntry<DateTime>) selectMonth;
  final DoubleLinkedQueueEntry<DateTime> selectedMonth;

  _MonthSliderViewModel({
    @required this.selectedMonth,
    @required this.selectMonth,
  });

  static _MonthSliderViewModel fromState(Store<AppState> store) {
    return _MonthSliderViewModel(
      selectedMonth: getSelectedMonth(store.state),
      selectMonth: (month) => store.dispatch(SelectMonth(month)),
    );
  }
}
