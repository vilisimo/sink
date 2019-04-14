import 'package:flutter/material.dart';
import 'package:sink/common/dot.dart';
import 'package:sink/ui/statistics/charts.dart';

class SortedBreakdown extends StatelessWidget {
  final List<ChartEntry> bars;
  final double maxAmount;
  final double totalAmount;

  SortedBreakdown._(this.bars, this.maxAmount, this.totalAmount);

  factory SortedBreakdown(List<ChartEntry> bars, {bool ascending}) {
    bars.sort();
    var asc = ascending ?? false;
    var sorted = asc ? bars.toList() : bars.reversed.toList();
    var max = asc ? sorted.last.amount : sorted.first.amount;
    var total = sorted.fold(0.0, (prev, next) => prev + next.amount);

    return SortedBreakdown._(
      sorted
          .map((b) => b.copyWith(maxAmount: max, totalAmount: total))
          .toList(),
      max,
      total,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircularBreakdown(data: bars, totalAmount: totalAmount),
        HorizontalBarChart(
            data: bars, maxAmount: maxAmount, totalAmount: totalAmount),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((datum) => ChartLabel(datum, totalAmount)).toList(),
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
        Text(
          "${(datum.amount / totalAmount * 100).toStringAsFixed(2)}%",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
