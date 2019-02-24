import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Entry {
  final String id;
  final double cost;
  final DateTime date;
  final String categoryId;
  final String description;

  Entry(
      {@required this.cost,
      @required this.date,
      @required this.categoryId,
      this.description,
      id})
      : this.id = id ?? Uuid().v4();

  static empty() {
    final now = DateTime.now();
    return Entry(cost: null, date: now, categoryId: '', description: '');
  }

  static fromSnapshot(DocumentSnapshot document) {
    return Entry(
      id: document['id'],
      cost: document['cost'],
      date: document['date'],
      categoryId: document['categoryId'],
      description: document['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'cost': this.cost,
      'date': this.date,
      'categoryId': this.categoryId,
      'description': this.description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cost == other.cost &&
          date == other.date &&
          categoryId == other.categoryId &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      cost.hashCode ^
      date.hashCode ^
      categoryId.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'Entry{id: $id, cost: $cost, date: $date, category: $categoryId, description: $description}';
  }
}
