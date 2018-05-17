import 'package:meta/meta.dart';

class Expense {

  Expense({
    @required this.cost,
    @required this.date,
    @required this.category,
    this.description
  });

  final double cost;
  final DateTime date;
  final String category;
  final String description;
}