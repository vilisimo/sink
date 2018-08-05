import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Entry {
  final String id;
  final double cost;
  final DateTime date;
  final String category;
  final String description;

  Entry(
      {@required this.cost,
      @required this.date,
      @required this.category,
      this.description,
      id})
      : this.id = id ?? Uuid().v4();

  static empty() {
    final now = DateTime.now();
    return Entry(cost: null, date: now, category: '', description: '');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Entry &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              cost == other.cost &&
              date == other.date &&
              category == other.category &&
              description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      cost.hashCode ^
      date.hashCode ^
      category.hashCode ^
      description.hashCode;



}
