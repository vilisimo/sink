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
    double maxWidth = MediaQuery.of(context).size.width;
    return Column(
      children: data.map((d) => _toHorizontalBar(d, maxWidth)).toList(),
    );
  }

  Widget _toHorizontalBar(ChartEntry entry, double maxWidth) {
    final widthPercentage = entry.amount / maxAmount;
    final percent = entry.amount / totalAmount * 100;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _HorizontalBarLabel(
            label: entry.label,
            percent: percent.toStringAsFixed(2),
            amount: entry.amount,
          ),
          AnimatedBar(
            width: maxWidth * widthPercentage,
            height: 20.0,
            color: entry.color,
            horizontal: true,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "$percent%",
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 12.0, color: Palette.dimBlueGrey),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "$amount",
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
