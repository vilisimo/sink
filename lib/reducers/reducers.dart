import 'package:sink/models/entry.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/models/state.dart';

AppState reduce(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case AddEntry:
      List<Entry> list = List.from(state.entries)..add(action.entry);
      list.sort((Entry a, Entry b) => a.date.isBefore(b.date) ? 1 : 0);
      return state.copyWith(entries: list);

    case EditEntry:
      List<Entry> items = List.from(state.entries);
      Entry newEntry = action.entry;
      int index = items.indexWhere((oldEntry) => newEntry.id == oldEntry.id);
      items[index] = newEntry;
      return state.copyWith(entries: items);

    case DeleteEntry:
      List<Entry> items = List.from(state.entries);
      List<Entry> removed = List.from(state.removed);
      items.remove(action.entry);
      removed.add(action.entry);
      return state.copyWith(entries: items, removed: removed);

    case UndoDelete:
      List<Entry> items = List.from(state.entries);
      List<Entry> removed = List.from(state.removed);
      items.add(removed.removeLast());
      items.sort((Entry a, Entry b) => a.date.isBefore(b.date) ? 1 : 0);
      return state.copyWith(entries: items, removed: removed);

    default:
      return state;
  }
}
