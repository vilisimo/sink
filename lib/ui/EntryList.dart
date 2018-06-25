import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/domain/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/ui/entry_item.dart';
import 'package:sink/ui/expense_form.dart';

class EntryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Entry>, Store<List<Entry>>>(
      converter: (store) => store,
      builder: (context, store) {
//              onDismissed: (DismissDirection direction) {
//                var item = entries[index];
//                setState(() {
//                  entries.removeAt(index);
//                });
//
//                _scaffoldKey.currentState.showSnackBar(SnackBar(
//                  content: Text('Entry removed'),
//                  action: SnackBarAction(
//                    label: "UNDO",
//                    onPressed: () => handleUndo(item, index),
//                  ),
//                ));
//              },

        return new ListView.builder(
          shrinkWrap: true,
          reverse: true,
          padding: EdgeInsets.all(8.0),
          itemCount: store.state.length,
          itemBuilder: (context, position) {
            return new Dismissible(
              key: ObjectKey(store.state[position]),
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
                store.dispatch(DeleteEntry(store.state[position]));
              },
              child: new InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          EditExpenseScreen(store.state[position], position)),
                  enableFeedback: true,
                  child: Card(child: EntryItem(store.state[position]))),
            );
          },
        );
      },
    );
  }
}
