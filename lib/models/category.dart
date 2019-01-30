import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    @required this.id,
    @required this.name,
    @required this.color,
  });

  static fromSnapshot(DocumentSnapshot document) {
    return Category(
      id: document['id'],
      name: document['name'],
      color: Color(document['color']),
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;
}
