import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/containers/add_edit_page.dart';
import 'package:sink/ui/presentation/entry_item.dart';

class EntryList extends StatelessWidget {
  final Function(Entry) onDismissed;
  final Function onUndo;

  EntryList({this.onDismissed, this.onUndo});

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreRepository.getEntriesSnapshot(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Scrollbar(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                Entry entry = Entry.fromSnapshot(document);
                return Dismissible(
                  key: ObjectKey(entry),
                  background: Card(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete),
                        )
                      ],
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
                  child: InkWell(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => EditExpenseScreen(entry)),
                      enableFeedback: true,
                      child: Card(child: EntryItem(entry))),
                );
              }).toList(),
            ),
          );
        });
  }
}
