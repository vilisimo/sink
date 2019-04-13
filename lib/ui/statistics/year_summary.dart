import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';

//TODO: show in bar chart?
class YearExpenses extends StatelessWidget {
  final DateTime from; // TODO: calculate -12 months from now
  final DateTime to;

  YearExpenses({@required this.from, @required this.to});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreRepository.snapshotBetween(from, to),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return PaddedCircularProgressIndicator();
          }

          List<Entry> entries = snapshot.data.documents
              .map((ds) => Entry.fromSnapshot(ds))
              .where((entry) => entry.type != EntryType.INCOME)
              .toList();

          Map<String, double> months = group(entries);
          List<Widget> monthlyExpenditures = months.entries
              .map((MapEntry<String, double> entry) =>
                  Text("${entry.key}: ${entry.value}"))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: monthlyExpenditures,
            ),
          );
        },
      ),
    );
  }
}

// TODO: explicit class for month's amount
Map<String, double> group(List<Entry> entries) {
  var months = Map<String, double>();
  entries.forEach((entry) => months.update(
      monthsName(entry.date), (value) => value + entry.amount,
      ifAbsent: () => entry.amount));

  return months;
}
