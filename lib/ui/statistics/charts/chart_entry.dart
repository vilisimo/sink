import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartEntry implements Comparable<ChartEntry> {
  final String label;
  final double amount;
  final Color color;
  final double maxAmount;
  final double totalAmount;

  ChartEntry({
    @required this.label,
    @required this.amount,
    color,
    maxAmount,
    totalAmount,
  })  : this.color = color ?? Colors.red,
        this.maxAmount = maxAmount ?? amount,
        this.totalAmount = totalAmount ?? amount;

  ChartEntry copyWith({
    double maxAmount,
    double totalAmount,
  }) {
    return ChartEntry(
      label: this.label,
      amount: this.amount,
      color: this.color,
      maxAmount: maxAmount ?? this.maxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  int compareTo(ChartEntry other) {
    if (this.amount > other.amount) {
      return 1;
    } else if (this.amount == other.amount) {
      return 0;
    } else {
      return -1;
    }
  }

  @override
  String toString() {
    return 'ChartEntry{label: $label, amount: $amount, color: $color, maxAmount: $maxAmount, totalAmount: $totalAmount}';
  }
}

class DatedChartEntry extends ChartEntry {
  DateTime date;

  DatedChartEntry({
    @required this.date,
    @required label,
    @required amount,
    color,
    maxAmount,
    totalAmount,
  }) : super(
          label: label,
          amount: amount,
          color: color,
          maxAmount: maxAmount,
          totalAmount: totalAmount,
        );

  @override
  DatedChartEntry copyWith({
    double maxAmount,
    double totalAmount,
  }) {
    return DatedChartEntry(
      date: this.date,
      label: this.label,
      amount: this.amount,
      color: this.color,
      maxAmount: maxAmount ?? this.maxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  String toString() {
    return 'DatedChartEntry{date: $date, label: $label, amount: $amount, color: $color, maxAmount: $maxAmount, totalAmount: $totalAmount}';
  }
}
