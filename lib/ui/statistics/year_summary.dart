import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/statistics/charts/chart_entry.dart';

class YearExpenses extends StatelessWidget {
  final DateTime from;
  final DateTime to;

  YearExpenses({@required this.to})
      : this.from = DateTime(to.year - 1, to.month + 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(top: 0.0),
      child: Card(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirestoreRepository.snapshotBetween(from, to),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return PaddedCircularProgressIndicator();
            }

            List<Entry> entries = snapshot.data.documents
                .where((ds) => ds['type'] != EntryType.INCOME.index)
                .map((ds) => Entry.fromSnapshot(ds))
                .toList();

            List<ChartEntry> months = toChartEntries(entries);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "${from.year} - ${to.year}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: months
                        .map(
                          (m) => Container(
                                width: MediaQuery.of(context).size.width / 14,
                                height: m.amount,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                ),
                              ),
                        )
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: months
                        .map(
                          (m) => Container(
                                width: MediaQuery.of(context).size.width / 14,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text("${m.label}"),
                                  ),
                                ),
                              ),
                        )
                        .toList(),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<ChartEntry> toChartEntries(List<Entry> entries) {
    var grouped = SplayTreeMap<DateTime, double>();
    entries.forEach((e) => grouped.update(
        DateTime(e.date.year, e.date.month), (value) => value + e.amount,
        ifAbsent: () => e.amount));

    return grouped.entries
        .map((e) => ChartEntry(label: monthsName(e.key), amount: e.value))
        .toList();
  }
}
