import 'package:sink/models/entry.dart';
import 'package:sink/redux/actions.dart';
import 'package:sink/redux/state.dart';

AppState reduce(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case DeleteEntry:
      // a hack that fixes flickering of entry upon its removal.
      // TODO: Why does returning new state cause a flicker?
      state.removed.add(action.entry);
      return state;

    case UndoDelete:
      List<Entry> removed = List.from(state.removed);
      removed.removeLast();
      return state.copyWith(removed: removed);

    case LoadCategories:
      return state.copyWith(
        categories: Set.from(action.categories),
        areCategoriesLoading: false,
      );

    default:
      return state;
  }
}
