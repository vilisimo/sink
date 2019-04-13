import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sink/common/palette.dart' as Palette;

class HorizontalBarChart extends StatelessWidget {
  final List<Bar> bars;

  HorizontalBarChart._(this.bars);

  factory HorizontalBarChart(List<Bar> bars, {bool ascending}) {
    bars.sort();
    var asc = ascending ?? false;
    var sorted = asc ? bars.toList() : bars.reversed.toList();
    var maxAmount = asc ? sorted.last.amount : sorted.first.amount;
    var total = sorted.fold(0.0, (prev, next) => prev + next.amount);

    return new HorizontalBarChart._(
      sorted
          .map((b) => b.copyWith(maxAmount: maxAmount, totalAmount: total))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bars,
    );
  }
}

class Bar extends StatelessWidget implements Comparable<Bar> {
  final String label;
  final double amount;
  final Color color;
  final double maxAmount;
  final double totalAmount;

  Bar({
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

  Bar copyWith({
    double maxAmount,
    double totalAmount,
  }) {
    return Bar(
      label: this.label,
      amount: this.amount,
      color: this.color,
      maxAmount: maxAmount ?? this.maxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  int compareTo(Bar other) {
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
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          Text(
            percent,
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
              borderRadius: BorderRadius.all(
                Radius.circular(9.0),
              ),
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
