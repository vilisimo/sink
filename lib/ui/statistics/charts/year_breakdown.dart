import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:sink/ui/statistics/charts/chart_components.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';
import 'package:sink/ui/statistics/charts/vertical_bar_chart.dart';

class YearBreakdown extends StatelessWidget {
  final String label;
  final List<DatedChartEntry> data;
  final double maxAmount;
  final double totalAmount;

  YearBreakdown._(this.label, this.data, this.maxAmount, this.totalAmount);

  factory YearBreakdown({
    @required String label,
    @required List<DatedChartEntry> data,
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
    return Column(
      children: <Widget>[
        ChartTitle(title: label),
        ChartSubtitle(subtitle: "Total: $totalAmount"),
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
          child: Divider(),
        ),
        VerticalBarChart(data: data, maxAmount: maxAmount, maxHeight: 250),
      ],
    );
  }
}
