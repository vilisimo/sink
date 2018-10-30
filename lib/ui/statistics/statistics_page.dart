import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SizedBox(
              child: DonutAutoLabelChart.withSampleData(),
              height: 250.0,
            ),
          ),
        ),
      ],
    );
  }
}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  factory DonutAutoLabelChart.withSampleData() {
    return new DonutAutoLabelChart(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  static List<charts.Series<Expense, String>> _createSampleData() {
    final data = [
      Expense("Clothes", 100, charts.Color.fromHex(code: "#90afc5")),
      Expense("Food", 75, charts.Color.fromHex(code: "#336b87")),
      Expense("Eating out", 25, charts.Color.fromHex(code: "#2a3132")),
      Expense("Electronics", 15, charts.Color.fromHex(code: "#763626")),
    ];

    return [
      new charts.Series<Expense, String>(
        id: 'Sales',
        domainFn: (Expense sales, _) => sales.label,
        measureFn: (Expense sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (Expense row, _) => '${row.label}: ${row.sales}',
        colorFn: (Expense sales, _) => sales.color,
      )
    ];
  }
}

class Expense {
  final String label;
  final int sales;
  final charts.Color color;

  Expense(this.label, this.sales, this.color);
}
