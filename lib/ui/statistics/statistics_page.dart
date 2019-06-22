import 'package:flutter/material.dart';
import 'package:sink/ui/statistics/month_summary.dart';
import 'package:sink/ui/statistics/year_summary.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        MonthExpenses(),
        YearExpenses(to: DateTime.now()),
      ],
    );
  }
}
