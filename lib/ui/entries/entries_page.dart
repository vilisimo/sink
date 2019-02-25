import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';
import 'package:sink/ui/common/progress_indicator.dart';
import 'package:sink/ui/entries/entry_list.dart';

class EntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        if (vm.loading) {
          return PaddedCircularProgressIndicator();
        }

        return Container(
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Expanded(child: EntryList()),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final bool loading;

  _ViewModel({@required this.loading});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      loading: areCategoriesLoading(store.state),
    );
  }
}
