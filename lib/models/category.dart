import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum CategoryType { EXPENSE, INCOME }

class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final CategoryType type;

  Category({
    @required this.id,
    @required this.name,
    @required this.icon,
    @required this.color,
    @required this.type,
  });

  static fromSnapshot(DocumentSnapshot document) {
    return Category(
      id: document['id'],
      name: document['name'],
      icon: document['icon'],
      color: Color(document['color']),
      type: document['type'] != null
          ? CategoryType.values[document['type']]
          : CategoryType.values[0],
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, icon: $icon, color: $color, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          color == other.color &&
          type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      icon.hashCode ^
      color.hashCode ^
      type.hashCode;
}
