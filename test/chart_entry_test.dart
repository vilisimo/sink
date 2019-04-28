import 'package:flutter/material.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';
import 'package:test/test.dart';

main() {
  test('expenditure with greater amount is considered to be greater', () {
    var greater = ChartEntry(
      label: "filler",
      amount: 1.0,
      color: Colors.red,
    );
    var smaller = ChartEntry(
      label: "filler",
      amount: 0.0,
      color: Colors.red,
    );

    expect(greater.compareTo(smaller), greaterThan(0));
  });

  test('expenditure with smaller amount is considered to be smaller', () {
    var greater = ChartEntry(
      label: "filler",
      amount: 1.0,
      color: Colors.red,
    );
    var smaller = ChartEntry(
      label: "filler",
      amount: 0.0,
      color: Colors.red,
    );

    expect(smaller.compareTo(greater), lessThan(0));
  });

  test('expenditure with equal amount is considered to be smaller', () {
    var e1 = ChartEntry(
      label: "filler",
      amount: 1.0,
      color: Colors.red,
    );
    var e2 = ChartEntry(
      label: "filler",
      amount: 1.0,
      color: Colors.red,
    );

    expect(e1.compareTo(e2), 0);
  });
}
