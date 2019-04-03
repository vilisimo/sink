import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sink/models/entry.dart';

double totalCost(List<DocumentSnapshot> snapshots) => snapshots
    .where((el) => el['type'] == EntryType.EXPENSE.index)
    .fold(0.0, (prev, next) => prev + next['cost']);

double totalIncome(List<DocumentSnapshot> snapshots) => snapshots
    .where((el) => el['type'] == EntryType.INCOME.index)
    .fold(0.0, (prev, next) => prev + next['cost']);
