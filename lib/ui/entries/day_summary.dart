import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/entry/entry_item.dart';

class DayGroup extends StatelessWidget {
  final List<Entry> _entries;
  final Function(Entry) _onDismissed;
  final Function _onUndo;
  final DateTime _date;
  final double _amount;

  DayGroup(this._entries, this._onDismissed, this._onUndo, this._date)
      : this._amount = _entries.fold(0.0, (sum, entry) => sum + entry.cost);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DaySummaryTile(_date, _amount),
        Column(
          children: _entries
              .map((entry) => EntryItem(entry, _onDismissed, _onUndo))
              .toList(),
        ),
      ],
    );
  }
}

class DaySummaryTile extends StatelessWidget {
  final dimBlueGrey = Color(Colors.blueGrey.value).withOpacity(0.7);

  final DateTime _date;
  final double _amount;

  DaySummaryTile(this._date, this._amount);

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
