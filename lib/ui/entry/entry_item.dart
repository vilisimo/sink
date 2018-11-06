import 'package:flutter/material.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/ui/entry/edit_entry_page.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;

  EntryItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.category),
      subtitle: Text(entry.description),
      trailing: Text("${entry.cost}", style: TextStyle(fontSize: 16.0),),
      onTap: () => showDialog(
          context: context,
          builder: (context) => EditExpensePage(entry)
      ),
    );
  }
}
