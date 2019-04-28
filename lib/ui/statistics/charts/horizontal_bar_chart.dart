import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sink/theme/palette.dart' as Palette;
import 'package:sink/ui/animation/bars.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

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
    return Column(children: data.map((d) => _toHorizontalBar(d)).toList());
  }

  Widget _toHorizontalBar(ChartEntry entry) {
    final widthPercentage = entry.amount / maxAmount;
    final percent = entry.amount / totalAmount * 100;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _HorizontalBarLabel(
            label: entry.label,
            percent: percent.toStringAsFixed(2),
            amount: entry.amount,
          ),
          AnimatedHorizontalBar(
            color: entry.color,
            percentOfScreen: widthPercentage,
          ),
        ],
      ),
    );
  }
}

class _HorizontalBarLabel extends StatelessWidget {
  final String label;
  final String percent;
  final double amount;

  _HorizontalBarLabel({
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
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "$percent%",
                    style:
                        TextStyle(fontSize: 12.0, color: Palette.dimBlueGrey),
                  ),
                ),
              ],
            ),
          ),
          Text("$amount", style: TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}
