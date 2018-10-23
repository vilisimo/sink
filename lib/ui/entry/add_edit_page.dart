import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/expense_form.dart';

class AddExpenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AddViewModel>(
      converter: _AddViewModel.fromState,
      builder: (context, vm) {
        return ExpenseForm(onSave: vm.onSave, entry: Entry.empty());
      },
    );
  }
}

class _AddViewModel {
  final Function(Entry) onSave;

  _AddViewModel({@required this.onSave});

  static _AddViewModel fromState(Store<AppState> store) {
    return _AddViewModel(onSave: (entry) => store.dispatch(AddEntry(entry)));
  }
}

class EditExpenseScreen extends StatelessWidget {
  final Entry entry;

  EditExpenseScreen(this.entry);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _EditViewModel>(
      converter: _EditViewModel.fromState,
      builder: (context, vm) {
        return ExpenseForm(onSave: vm.onSave, entry: this.entry);
      },
    );
  }
}

class _EditViewModel {
  final Function(Entry) onSave;

  _EditViewModel({@required this.onSave});

  static _EditViewModel fromState(Store<AppState> store) {
    return _EditViewModel(onSave: (entry) => store.dispatch(EditEntry(entry)));
  }
}
