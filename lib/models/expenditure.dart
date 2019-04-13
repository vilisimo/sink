import 'package:flutter/material.dart';

/// Represents an expense. Mostly used in statistics page(s) to group entries by
/// month, category, etc.
class Expenditure<T> implements Comparable<Expenditure> {
  final T bucket;
  final double amount;

  Expenditure({@required this.bucket, @required this.amount});

  @override
  int compareTo(Expenditure other) {
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
    return 'Expenditure{bucket: $bucket, amount: $amount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expenditure &&
          runtimeType == other.runtimeType &&
          bucket == other.bucket &&
          amount == other.amount;

  @override
  int get hashCode => bucket.hashCode ^ amount.hashCode;
}
