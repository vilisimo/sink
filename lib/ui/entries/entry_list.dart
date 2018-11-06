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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ));
          }

          return Expanded(
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  Entry entry = Entry.fromSnapshot(document);
                  return Dismissible(
                    key: ObjectKey(entry),
                    background: Container(
                      color: Colors.red,
                      child: ListTile(
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      onDismissed(entry);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text('Entry removed'),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: onUndo,
                        ),
                      ));
                    },
                    child: EntryItem(entry),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
