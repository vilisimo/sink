import 'package:sink/models/entry.dart';
import 'package:sink/actions/actions.dart';
import 'package:sink/models/state.dart';

AppState reduce(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case AddEntry:
      return state.copyWith(
          entries: List.from(state.entries)..add(action.entry));

    case EditEntry:
      List<Entry> items = List.from(state.entries);
      Entry newEntry = action.entry;
      int index = items.indexWhere((oldEntry) => newEntry.id == oldEntry.id);
      items[index] = newEntry;
      return state.copyWith(entries: items);

    case DeleteEntry:
      List<Entry> items = List.from(state.entries);
      items.remove(action.entry);
      return state.copyWith(
          entries: items,
          lastEntry: action.entry,
          lastEntryIndex: action.index);

    case UndoDelete:
      List<Entry> items = List.from(state.entries);
      items.insert(state.lastEntryIndex, state.lastEntry);
      return state.copyWith(entries: items);

    default:
      return state;
  }
}
