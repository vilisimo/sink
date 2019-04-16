import 'package:flutter/material.dart';
import 'package:sink/theme/palette.dart' as Palette;

/// Displays expense/income amount. Depending on type of entry, shows an icon
/// indicating whether it is an expense or an income.
class VisualizedAmount extends StatelessWidget {
  static const incomeIcon = Icons.keyboard_arrow_up;
  static const expenseIcon = Icons.keyboard_arrow_down;
  static const iconScalingFactor = 1.25;

  final double amount;
  final bool income;
  final TextStyle style;

  VisualizedAmount({
    @required this.amount,
    @required this.income,
    style,
  }) : this.style = style ?? TextStyle(fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("$amount", style: style),
        Icon(
          income ? incomeIcon : expenseIcon,
          color: income ? Palette.income : Palette.expense,
          size: style.fontSize * iconScalingFactor,
        ),
      ],
    );
  }
}
