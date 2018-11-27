import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/ui/entries/entry_list.dart';
import 'package:sink/ui/statistics/interval_expense.dart';

class EntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // workaround to show shadows
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Expanded(child: EntryList()),
          IntervalExpense(from: currentFirst(), to: currentLast()),
        ],
      ),
    );
  }
}
