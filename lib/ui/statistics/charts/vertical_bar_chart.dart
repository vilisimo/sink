import 'package:flutter/material.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

class VerticalBarChart extends StatelessWidget {
  static const EdgeInsetsGeometry _padding =
      const EdgeInsets.only(left: 2.0, right: 2.0);

  final List<ChartEntry> data;
  final double maxAmount;
  final double maxHeight;

  VerticalBarChart({
    @required this.data,
    @required this.maxAmount,
    @required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var barWidth = screenSize.width / 18;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.map((m) => _toVerticalBar(m, barWidth)).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((m) => _toBarLabel(m, barWidth)).toList(),
          )
        ],
      ),
    );
  }

  Widget _toVerticalBar(ChartEntry entry, double width) {
    final heightPercentage = entry.amount / maxAmount;

    return Column(
      children: <Widget>[
        RotatedBox(
          quarterTurns: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "${entry.amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        Padding(
          padding: _padding,
          child: Container(
            width: width,
            height: maxHeight * heightPercentage,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _toBarLabel(ChartEntry entry, double width) {
    return Padding(
      padding: _padding,
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: RotatedBox(
          quarterTurns: 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text("${entry.label}"),
          ),
        ),
      ),
    );
  }
}
