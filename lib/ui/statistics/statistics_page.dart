import 'package:flutter/material.dart';
import 'package:sink/ui/statistics/month_summary.dart';
import 'package:sink/ui/statistics/year_summary.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        MonthExpenses(
          from: DateTime.now().subtract(Duration(days: 300)),
          to: DateTime.now(),
        ),
        YearExpenses(
          from: DateTime(2018, 5, 0),
          to: DateTime.now(),
        ),
      ],
    );
  }
}
