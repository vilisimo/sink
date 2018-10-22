import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/ui/presentation/entry_list.dart';
import 'package:sink/utils/calendar.dart';

class EntriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (context, vm) {
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreRepository.snapshotBetween(
                      currentFirst(), currentLast()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<DocumentSnapshot> list = snapshot.data.documents;
                    var total = 0.0;
                    list.forEach((doc) => total += doc.data['cost']);

                    return ListTile(
                        title: Center(
                            child: Text(
                                (currentMonth() + " expenses:").toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold))),
                        subtitle: Center(
                            child: Text(total.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold))));
                  },
                ),
              ),
              EntryList(
                onDismissed: vm.onDismissed,
                onUndo: vm.onUndo,
              ),
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
