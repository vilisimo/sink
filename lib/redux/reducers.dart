import 'package:sink/domain/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';

AppState reduce(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case AddEntry:
      return AppState.copyWith(
          entries: List.from(state.entries)..add(action.entry));

    case EditEntry:
      List<Entry> items = List.from(state.entries);
      items[action.index] = action.entry;
      return AppState.copyWith(entries: items);

    case DeleteEntry:
      List<Entry> items = List.from(state.entries);
      items.remove(action.entry);
      return AppState.copyWith(
          entries: items,
          lastEntry: action.entry,
          lastEntryIndex: action.index);

    case UndoDelete:
      List<Entry> items = List.from(state.entries);
      items.insert(state.lastEntryIndex, state.lastEntry);
      return AppState.copyWith(entries: items);

    default:
      return state;
  }
}
