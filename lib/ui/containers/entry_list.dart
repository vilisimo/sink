import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/selectors/selectors.dart';
import 'package:sink/models/state.dart';
import 'package:sink/ui/containers/entry_item.dart';
import 'package:sink/ui/containers/expense_form.dart';

class EntryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return new ListView.builder(
          shrinkWrap: true,
          reverse: true,
          padding: EdgeInsets.all(8.0),
          itemCount: vm.count,
          itemBuilder: (context, position) {
            return new Dismissible(
              key: ObjectKey(vm.entries[position]),
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
                vm.onDismissed(vm.entries[position], position);
                Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text('Entry removed'),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: vm.onUndo,
                      ),
                    ));
              },
              child: new InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          EditExpenseScreen(vm.entries[position], position)),
                  enableFeedback: true,
                  child: Card(child: EntryItem(vm.entries[position]))),
            );
          },
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  final Function(Entry, int) onDismissed;
  final Function onUndo;
  final List<Entry> entries;
  final int count;

  _ViewModel(
      {@required this.entries,
      @required this.onDismissed,
      @required this.onUndo})
      : this.count = entries.length;

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
        entries: getEntries(store.state),
        onDismissed: (entry, position) {
          store.dispatch(DeleteEntry(entry, position));
        },
        onUndo: () {
          store.dispatch(UndoDelete());
        });
  }
}
