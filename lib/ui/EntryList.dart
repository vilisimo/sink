import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/entry_item.dart';
import 'package:sink/ui/expense_form.dart';

class EntryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return new ListView.builder(
          shrinkWrap: true,
          reverse: true,
          padding: EdgeInsets.all(8.0),
          itemCount: store.state.entries.length,
          itemBuilder: (context, position) {
            return new Dismissible(
              key: ObjectKey(store.state.entries[position]),
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
                store.dispatch(DeleteEntry(store.state.entries[position], position));
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text('Entry removed'),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () => store.dispatch(UndoDelete()),
                  ),
                ));
              },
              child: new InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => EditExpenseScreen(
                          store.state.entries[position], position)),
                  enableFeedback: true,
                  child: Card(child: EntryItem(store.state.entries[position]))),
            );
          },
        );
      },
    );
  }
}
