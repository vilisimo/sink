import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';
import 'package:sink/ui/statistics/charts/vertical_bar_chart.dart';

class YearBreakdown extends StatelessWidget {
  final String label;
  final List<ChartEntry> data;
  final double maxAmount;
  final double totalAmount;

  YearBreakdown._(this.label, this.data, this.maxAmount, this.totalAmount);

  factory YearBreakdown({
    @required String label,
    @required List<ChartEntry> data,
  }) {
    var amounts = data.map((ce) => ce.amount);
    var maxAmount = max(amounts);
    var totalAmount = amounts.reduce((a, b) => a + b);

    return YearBreakdown._(
      label,
      data
          .map(
              (d) => d.copyWith(maxAmount: maxAmount, totalAmount: totalAmount))
          .toList(),
      maxAmount,
      totalAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          Text(
            "Total: $totalAmount",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
            child: Divider(),
          ),
          VerticalBarChart(
            data: data,
            maxAmount: maxAmount,
            maxHeight: 250,
          ),
        ],
      ),
    );
  }
}
