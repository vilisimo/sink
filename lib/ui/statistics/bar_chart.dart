import 'package:flutter/material.dart';

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
    final partOfTotal = amount / totalAmount * 100;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //TODO: largest expense = 100%; others = 100 * x (given x < 1.0);
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6 * widthPercentage,
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
          Text("$label : $amount : ${partOfTotal.roundToDouble()}%")
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
