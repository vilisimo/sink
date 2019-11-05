import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/theme/icons.dart';
import 'package:sink/ui/common/amount.dart';
import 'package:sink/ui/entries/edit_entry_page.dart';

class EntryItem extends StatelessWidget {
  final Key key;
  final Entry entry;

  EntryItem(this.entry) : key = ObjectKey(entry);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (state) => _ViewModel.fromState(state, entry.categoryId),
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
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    width: ICON_BACKGROUND_SIZE,
                    height: ICON_BACKGROUND_SIZE,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vm.category.color,
                      ),
                      child: Icon(
                        icons[vm.category.icon],
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(vm.category.name),
                    subtitle: Text(entry.description),
                    trailing: VisualizedAmount(
                      amount: entry.amount,
                      income: entry.type == EntryType.INCOME,
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      EditExpensePage.route,
                      arguments: EditExpensePageArgs(entry),
                    ),
                  ),
                ),
              ],
            ),
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
  final Category category;

  _ViewModel({
    @required this.onDismissed,
    @required this.onUndo,
    @required this.category,
  });

  static _ViewModel fromState(Store<AppState> store, String categoryId) {
    return _ViewModel(
      onDismissed: (entry) => store.dispatch(DeleteEntry(entry)),
      onUndo: () => store.dispatch(UndoDelete()),
      category: getCategory(store.state, categoryId),
    );
  }
}
