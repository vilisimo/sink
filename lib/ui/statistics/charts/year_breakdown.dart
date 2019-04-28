import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

class YearBreakdown extends StatelessWidget {
  final String label;
  final List<ChartEntry> data;
  final double maxAmount;
  final double total;

  YearBreakdown._(this.label, this.data, this.maxAmount, this.total);

  factory YearBreakdown({
    @required String label,
    @required List<ChartEntry> data,
  }) {
    var amounts = data.map((ce) => ce.amount);
    var maxAmount = max(amounts);
    var totalAmount = amounts.reduce((a, b) => a + b);

    return YearBreakdown._(label, data, maxAmount, totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data
                .map(
                  (m) => Container(
                        width: MediaQuery.of(context).size.width / 14,
                        height: m.amount,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                        ),
                      ),
                )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data
                .map(
                  (m) => Container(
                        width: MediaQuery.of(context).size.width / 14,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("${m.label}"),
                          ),
                        ),
                      ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
