import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/entry_form.dart';

class AddExpensePage extends StatelessWidget {
  static const route = '/expense/add';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AddViewModel>(
      converter: _AddViewModel.fromState,
      builder: (context, vm) {
        return EntryForm(
          onSave: vm.onSave,
          entry: Entry.empty(),
        );
      },
    );
  }
}

class _AddViewModel {
  final Function(Entry) onSave;

  _AddViewModel({@required this.onSave});

  static _AddViewModel fromState(Store<AppState> store) {
    return _AddViewModel(
      onSave: (entry) => store.dispatch(AddEntry(entry)),
    );
  }
}
