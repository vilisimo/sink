import 'package:cloud_firestore/cloud_firestore.dart';

double totalCost(List<DocumentSnapshot> snapshots) =>
  snapshots.fold(0.0, (prev, next) => prev + next['cost']);