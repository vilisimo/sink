import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

class CircularChart extends StatelessWidget {
  final _chartKey = GlobalKey<AnimatedCircularChartState>();

  final List<CircularStackEntry> data;
  final double totalAmount;

  CircularChart._(this.data, this.totalAmount);

  factory CircularChart({
    @required List<ChartEntry> data,
    @required double totalAmount,
  }) {
    var entries = data.map((bar) => toEntry(bar)).toList();
    var result = [CircularStackEntry(entries, rankKey: "Categories")];

    return CircularChart._(result, totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width / 2;

    return AnimatedCircularChart(
      key: _chartKey,
      size: Size(radius, radius),
      initialChartData: data,
      chartType: CircularChartType.Radial,
      holeRadius: radius / 5,
      holeLabel: "${totalAmount.toStringAsFixed(2)}",
      labelStyle: Theme.of(context).textTheme.body1,
      edgeStyle: SegmentEdgeStyle.round,
    );
  }

  static CircularSegmentEntry toEntry(ChartEntry bar) => CircularSegmentEntry(
        bar.amount,
        bar.color,
        rankKey: bar.label,
      );
}
