import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sink/common/palette.dart' as Palette;
import 'package:sink/models/entry.dart';

class DaySummaryTile extends StatelessWidget {
  final DateTime _date;
  final double _amount;

  DaySummaryTile(this._date, entries) : this._amount = _totalAmount(entries);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              DateFormat.yMMMMd().format(_date),
              style: TextStyle(fontSize: 12.0, color: Palette.dimBlueGrey),
            ),
          ),
          Text(
            _amount.toString(),
            style: TextStyle(
              color: Palette.dimBlueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

double _totalAmount(List<Entry> entries) =>
    entries.fold(0.0, (sum, entry) => sum + entry.cost);
