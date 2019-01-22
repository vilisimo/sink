import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/expense_form.dart';

class AddExpensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AddViewModel>(
      converter: _AddViewModel.fromState,
      builder: (context, vm) {
        return ExpenseForm(
          onSave: vm.onSave,
          categories: vm.categories,
          entry: Entry.empty(),
        );
      },
    );
  }
}

class _AddViewModel {
  final Function(Entry) onSave;
  final List<String> categories;

  _AddViewModel({@required this.onSave, @required this.categories});

  static _AddViewModel fromState(Store<AppState> store) {
    return _AddViewModel(
      onSave: (entry) => store.dispatch(AddEntry(entry)),
      categories: getCategories(store.state),
    );
  }
}
