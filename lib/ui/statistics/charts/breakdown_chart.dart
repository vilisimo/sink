import 'package:flutter/material.dart';
import 'package:sink/ui/common/dot.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';
import 'package:sink/ui/statistics/month_summary.dart';

import 'circular_chart.dart';
import 'horizontal_bar_chart.dart';

class SortedBreakdown extends StatelessWidget {
  final String month;
  final List<ChartEntry> data;
  final double maxAmount;
  final double totalAmount;

  SortedBreakdown._(
    this.month,
    this.data,
    this.maxAmount,
    this.totalAmount,
  );

  factory SortedBreakdown({
    @required String month,
    @required List<ChartEntry> data,
    bool ascending,
  }) {
    data.sort();
    var asc = ascending ?? false;
    var sorted = asc ? data.toList() : data.reversed.toList();
    var max = asc ? sorted.last.amount : sorted.first.amount;
    var total = sorted.fold(0.0, (prev, next) => prev + next.amount);

    return SortedBreakdown._(
      month,
      sorted
          .map((d) => d.copyWith(maxAmount: max, totalAmount: total))
          .toList(),
      max,
      total,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MonthSlider(),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8.0, right: 24.0),
          child: Divider(),
        ),
        CircularBreakdown(data: data, totalAmount: totalAmount),
        HorizontalBarChart(
            data: data, maxAmount: maxAmount, totalAmount: totalAmount),
      ],
    );
  }
}

class CircularBreakdown extends StatelessWidget {
  final List<ChartEntry> data;
  final double totalAmount;

  CircularBreakdown({@required this.data, @required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CircularChart(data: data, totalAmount: totalAmount),
        ChartLegend(data, totalAmount),
      ],
    );
  }
}

class ChartLegend extends StatelessWidget {
  final List<ChartEntry> data;
  final double totalAmount;

  ChartLegend(this.data, this.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: data.map((datum) => ChartLabel(datum, totalAmount)).toList(),
      ),
    );
  }
}

class ChartLabel extends StatelessWidget {
  final ChartEntry datum;
  final double totalAmount;

  ChartLabel(this.datum, this.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColoredDot(
          radius: 7.0,
          color: datum.color,
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  datum.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "${(datum.amount / totalAmount * 100).toStringAsFixed(2)}%",
              ),
            ],
          ),
        )
      ],
    );
  }
}
