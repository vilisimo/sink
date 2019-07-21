import 'package:flutter/material.dart';
import 'package:sink/ui/animation/bars.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

const HEIGHT_PER_CHARACTER = 8;

class VerticalBarChart extends StatelessWidget {
  static const EdgeInsetsGeometry _padding =
      const EdgeInsets.only(left: 2.0, right: 2.0);

  final List<DatedChartEntry> data;
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

  Widget _toVerticalBar(DatedChartEntry entry, double width) {
    final heightPercentage = entry.amount / maxAmount;
    final amount = entry.amount.toStringAsFixed(2);
    // fixme: a hack to prevent expansion of stats card
    final textSize = amount.length * HEIGHT_PER_CHARACTER;

    return Container(
      constraints: BoxConstraints(
        minHeight: maxHeight + textSize,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        key: ObjectKey(entry),
        children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(amount, style: TextStyle(fontSize: 12.0)),
            ),
          ),
          Padding(
            key: ObjectKey(entry),
            padding: _padding,
            child: AnimatedBar(
              width: width,
              height: maxHeight * heightPercentage,
              color: entry.color,
              horizontal: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toBarLabel(ChartEntry entry, double width) {
    return Padding(
      key: ObjectKey(entry),
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
