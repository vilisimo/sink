import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

enum EntryType { EXPENSE, INCOME }

class Entry {
  final String id;
  final double cost;
  final DateTime date;
  final String categoryId;
  final String description;
  final EntryType type;

  Entry({
    @required this.cost,
    @required this.date,
    @required this.categoryId,
    @required this.type,
    this.description,
    id,
  }) : this.id = id ?? Uuid().v4();

  static empty() {
    return Entry(
      cost: null,
      date: DateTime.now(),
      categoryId: '',
      type: EntryType.EXPENSE,
      description: '',
    );
  }

  static fromSnapshot(DocumentSnapshot document) {
    return Entry(
      id: document['id'],
      cost: document['cost'],
      date: document['date'],
      categoryId: document['categoryId'],
      description: document['description'],
      type: document['type'] != null
          ? EntryType.values[document['type']]
          : EntryType.values[0],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'cost': this.cost,
      'date': this.date,
      'categoryId': this.categoryId,
      'description': this.description,
      'type': this.type.index,
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
          description == other.description &&
          type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^
      cost.hashCode ^
      date.hashCode ^
      categoryId.hashCode ^
      description.hashCode ^
      type.hashCode;

  @override
  String toString() {
    return 'Entry{id: $id, cost: $cost, date: $date, categoryId: $categoryId, description: $description, type: $type}';
  }
}
