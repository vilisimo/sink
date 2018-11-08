import 'package:flutter/material.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/entries/edit_entry_page.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;
  final Function(Entry) onDismissed;
  final Function onUndo;

  EntryItem(this.entry, this.onDismissed, this.onUndo);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(entry),
        background: Container(
          color: Colors.red,
          child: ListTile(),
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
        child: ListTile(
          title: Text(entry.category),
          subtitle: Text(entry.description),
          trailing: Text(
            "${entry.cost}",
            style: TextStyle(fontSize: 16.0),
          ),
          onTap: () => showDialog(
              context: context, builder: (context) => EditExpensePage(entry)),
        )
    );
  }
}
