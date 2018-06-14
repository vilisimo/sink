import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/ui/entry_item.dart';

class EntryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Entry>, List<Entry>>(
      converter: (store) => store.state,
      builder: (context, list) {
        return new ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, position) => new EntryItem(list[position]),
        );
      },
    );
  }
}
