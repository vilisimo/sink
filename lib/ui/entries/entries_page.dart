import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/entries/entry_list.dart';
import 'package:sink/ui/statistics/interval_expense.dart';
import 'package:sink/utils/calendar.dart';

class EntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return Container(
          child: Column(
            // workaround to show shadows
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              EntryList(onDismissed: vm.onDismissed, onUndo: vm.onUndo),
              IntervalExpense(from: currentFirst(), to: currentLast()),
            ],
          ),
        );
      },
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
