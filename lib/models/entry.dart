import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Entry {
  Entry(
      {@required this.cost,
      @required this.date,
      @required this.category,
      this.description,
      id})
      : this.id = id ?? Uuid().v4();

  static empty() {
    return Entry(
        cost: null, date: DateTime.now(), category: '', description: '');
  }

  final String id;
  final double cost;
  final DateTime date;
  final String category;
  final String description;
}
