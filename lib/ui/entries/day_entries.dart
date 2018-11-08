import 'package:flutter/material.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/entries/entry_item.dart';
import 'package:sink/ui/statistics/day_summary.dart';

class DayGroup extends StatelessWidget {
  final List<Entry> _entries;
  final Function(Entry) _onDismissed;
  final Function _onUndo;
  final DateTime _date;

  DayGroup(this._entries, this._onDismissed, this._onUndo, this._date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DaySummaryTile(_date, _entries),
        Column(
          children: _entries
              .map((entry) => EntryItem(entry, _onDismissed, _onUndo))
              .toList(),
        ),
      ],
    );
  }
}
