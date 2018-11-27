import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/entries/edit_entry_page.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;

  EntryItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel> (
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return Dismissible(
            key: ObjectKey(entry),
            background: Container(
              color: Colors.red,
              child: ListTile(),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (DismissDirection direction) {
              vm.onDismissed(entry);
              Scaffold.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Text('Entry removed'),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: vm.onUndo,
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
              onTap: () =>
                  showDialog(
                      context: context,
                      builder: (context) => EditExpensePage(entry)),
            )
        );
      }
    );
  }
}

@immutable
class _ViewModel {
  final Function(Entry) onDismissed;
  final Function onUndo;

  _ViewModel({@required this.onDismissed, @required this.onUndo});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      onDismissed: (entry) => store.dispatch(DeleteEntry(entry)),
      onUndo: () => store.dispatch(UndoDelete()),
    );
  }
}

