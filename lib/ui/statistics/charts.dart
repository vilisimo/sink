import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:sink/common/palette.dart' as Palette;

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
      labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      edgeStyle: SegmentEdgeStyle.round,
    );
  }

  static CircularSegmentEntry toEntry(ChartEntry bar) => CircularSegmentEntry(
        bar.amount,
        bar.color,
        rankKey: bar.label,
      );
}

class HorizontalBarChart extends StatelessWidget {
  final List<ChartEntry> data;
  final double maxAmount;
  final double totalAmount;

  HorizontalBarChart({
    @required this.data,
    @required this.maxAmount,
    @required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: data);
  }
}

class ChartEntry extends StatelessWidget implements Comparable<ChartEntry> {
  final String label;
  final double amount;
  final Color color;
  final double maxAmount;
  final double totalAmount;

  ChartEntry({
    @required this.label,
    @required this.amount,
    @required this.color,
    maxAmount,
    totalAmount,
  })  : this.maxAmount = maxAmount ?? amount,
        this.totalAmount = totalAmount ?? amount;

  @override
  Widget build(BuildContext context) {
    final widthPercentage = amount / maxAmount;
    final percent = amount / totalAmount * 100;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        children: <Widget>[
          _BarLabel(
            label: label,
            percent: percent.toStringAsFixed(2),
            amount: amount,
          ),
          _ColoredBar(
            color: color,
            percentOfScreen: widthPercentage,
          ),
        ],
      ),
    );
  }

  ChartEntry copyWith({
    double maxAmount,
    double totalAmount,
  }) {
    return ChartEntry(
      label: this.label,
      amount: this.amount,
      color: this.color,
      maxAmount: maxAmount ?? this.maxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  int compareTo(ChartEntry other) {
    if (this.amount > other.amount) {
      return 1;
    } else if (this.amount == other.amount) {
      return 0;
    } else {
      return -1;
    }
  }
}

class _BarLabel extends StatelessWidget {
  final String label;
  final String percent;
  final double amount;

  _BarLabel({
    @required this.label,
    @required this.percent,
    @required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(label, style: TextStyle(fontSize: 14.0)),
          ),
          Text(
            "$percent%",
            style: TextStyle(
              fontSize: 12.0,
              color: Palette.dimBlueGrey,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                "$amount",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColoredBar extends StatelessWidget {
  final Color color;
  final percentOfScreen;

  _ColoredBar({
    @required this.color,
    @required this.percentOfScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * percentOfScreen,
          height: 20.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
