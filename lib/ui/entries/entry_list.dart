import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/entry/entry_item.dart';

class EntryList extends StatelessWidget {
  final Function(Entry) onDismissed;
  final Function onUndo;

  EntryList({this.onDismissed, this.onUndo});

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreRepository.getEntriesSnapshot(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }

        var documents = snapshot.data.documents;
        return Expanded(
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              children: documents.map((DocumentSnapshot doc) {
                return EntryItem(Entry.fromSnapshot(doc), onDismissed, onUndo);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
