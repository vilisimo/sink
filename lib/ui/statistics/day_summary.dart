import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sink/models/entry.dart';

class DaySummaryTile extends StatelessWidget {
  final dimBlueGrey = Color(Colors.blueGrey.value).withOpacity(0.7);

  final DateTime _date;
  final double _amount;

  DaySummaryTile(this._date, entries) : this._amount = _totalAmount(entries);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        DateFormat.yMMMMd().format(_date),
        style: TextStyle(fontSize: 14.0, color: dimBlueGrey),
      ),
      trailing: Text(
        _amount.toString(),
        style: TextStyle(color: dimBlueGrey),
      ),
    );
  }
}

double _totalAmount(List<Entry> entries) =>
    entries.fold(0.0, (sum, entry) => sum + entry.cost);
