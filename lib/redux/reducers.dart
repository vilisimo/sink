import 'package:sink/domain/entry.dart';
import 'package:sink/redux/actions.dart';

List<Entry> reduce(List<Entry> entries, dynamic action) {
  switch (action) {
    case AddEntry:
      return List.from(entries)..add(action.entry);

    case EditEntry:
      return List
          .from(entries)
          .map((entry) => entry.id == action.entry.id ? action.entry : entry)
          .toList();

    case DeleteEntry:
      List<Entry> items = List.from(entries);
      items.remove(action.entry);
      return items;

    default:
      throw "Action not recognized";
  }
}
