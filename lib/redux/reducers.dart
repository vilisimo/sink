import 'package:sink/domain/entry.dart';
import 'package:sink/redux/actions.dart';

List<Entry> reduce(List<Entry> entries, dynamic action) {
  switch (action.runtimeType) {
    case AddEntry:
      return List.from(entries)..add(action.entry);

    case EditEntry:
      List<Entry> items = List.from(entries);
      items[action.index] = action.entry;
      return items;

    case DeleteEntry:
      List<Entry> items = List.from(entries);
      items.remove(action.entry);
      return items;

    default:
      throw "Action not recognized";
  }
}
