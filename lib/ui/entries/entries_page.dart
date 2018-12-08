import 'package:flutter/material.dart';
import 'package:sink/ui/entries/entry_list.dart';

class EntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Expanded(child: EntryList()),
        ],
      ),
    );
  }
}
