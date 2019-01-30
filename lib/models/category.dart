import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Category {
  final String name;
  final Color color;

  Category({@required this.name, @required this.color});

  static fromSnapshot(DocumentSnapshot document) {
    return Category(name: document['name'], color: Color(document['color']));
  }

  @override
  String toString() {
    return 'Category{name: $name, color: $color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          color == other.color;

  @override
  int get hashCode => name.hashCode ^ color.hashCode;
}
