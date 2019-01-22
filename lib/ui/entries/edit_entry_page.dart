import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/forms/expense_form.dart';

class EditExpensePage extends StatelessWidget {
  final Entry entry;

  EditExpensePage(this.entry);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _EditViewModel>(
      converter: _EditViewModel.fromState,
      builder: (context, vm) {
        return ExpenseForm(
          onSave: vm.onSave,
          categories: vm.categories,
          entry: this.entry,
        );
      },
    );
  }
}

class _EditViewModel {
  final Function(Entry) onSave;
  final List<String> categories;

  _EditViewModel({@required this.onSave, @required this.categories});

  static _EditViewModel fromState(Store<AppState> store) {
    return _EditViewModel(
      onSave: (entry) => store.dispatch(EditEntry(entry)),
      categories: getCategories(store.state),
    );
  }
}
