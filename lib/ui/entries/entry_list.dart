import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/entries/day_summary.dart';

class EntryList extends StatelessWidget {
  final Function(Entry) onDismissed;
  final Function onUndo;

  EntryList({this.onDismissed, this.onUndo});

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreRepository.getEntriesSnapshot(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return PaddedCircularProgressIndicator();
        }

        var grouped = groupEntries(snapshot.data.documents);

        return Expanded(
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              children: grouped.entries.map((entry) {
                return DayGroup(entry.value, onDismissed, onUndo, entry.key);
              }).toList(),
            ),
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
