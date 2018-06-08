import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Entry {

  Entry({
    @required this.cost,
    @required this.date,
    @required this.category,
    this.description
  });

  final Uuid id = Uuid().v4();
  final double cost;
  final DateTime date;
  final String category;
  final String description;
}