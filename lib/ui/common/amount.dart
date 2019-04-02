import 'package:flutter/material.dart';
import 'package:sink/common/palette.dart' as Palette;
import 'package:sink/models/entry.dart';

/// Displays expense/income amount. Depending on type of entry, shows an icon
/// indicating whether it is an expense or an income.
class VisualizedAmount extends StatelessWidget {
  final double amount;
  final EntryType entryType;
  final IconData iconData;
  final Color color;

  VisualizedAmount({@required this.amount, @required this.entryType})
      : iconData = entryType == EntryType.EXPENSE
            ? Icons.keyboard_arrow_down
            : Icons.keyboard_arrow_up,
        color =
            entryType == EntryType.EXPENSE ? Palette.income : Palette.expense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("$amount", style: TextStyle(fontSize: 16.0)),
        Icon(iconData, color: color),
      ],
    );
  }
}
