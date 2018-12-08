import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/entries/day_entries.dart';
import 'package:sink/ui/statistics/balance.dart';

class EntryList extends StatelessWidget {

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreRepository.getEntriesSnapshot(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return PaddedCircularProgressIndicator();
        }

        var grouped = groupEntries(snapshot.data.documents);
        var children = grouped.entries.map((entry) {
          return DayGroup(entry.value, entry.key);
        }).toList();
        List<Widget> ch = [BalanceCard(from: currentFirst(), to: currentLast())];
        ch.addAll(children);

        return Scrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(8.0),
            children: ch,
          ),
        );
      },
    );
  }
}

Map<DateTime, List<Entry>> groupEntries(List<DocumentSnapshot> snapshots) {
  var entries = new Map<DateTime, List<Entry>>();
  snapshots.forEach((s) {
    Entry entry = Entry.fromSnapshot(s);
    DateTime dateKey = startOfDay(entry.date);

    if (!entries.containsKey(dateKey)) {
      entries[dateKey] = [entry];
    } else {
      entries[dateKey].add(entry);
    }
  });

  return entries;
}
