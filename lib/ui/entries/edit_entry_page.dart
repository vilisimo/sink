import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/entry_form.dart';

class EditExpensePageArgs {
  final Entry entry;

  EditExpensePageArgs(this.entry);
}

class EditExpensePage extends StatelessWidget {
  static const route = '/expense/edit';

  @override
  Widget build(BuildContext context) {
    final EditExpensePageArgs args = ModalRoute.of(context).settings.arguments;
    return StoreConnector<AppState, _EditViewModel>(
      converter: _EditViewModel.fromState,
      builder: (context, vm) {
        return EntryForm(
          onSave: vm.onSave,
          entry: args.entry,
        );
      },
    );
  }
}

class _EditViewModel {
  final Function(Entry) onSave;

  _EditViewModel({@required this.onSave});

  static _EditViewModel fromState(Store<AppState> store) {
    return _EditViewModel(
      onSave: (entry) => store.dispatch(EditEntry(entry)),
    );
  }
}
