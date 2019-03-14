import 'package:sink/common/exceptions.dart';
import 'package:sink/models/entry.dart';

String toString(dynamic e) => e.toString().split('.')[1].toLowerCase();

String toCapitalizedString(dynamic e) {
  var result = toString(e);
  return result[0].toUpperCase() + result.substring(1);
}

List<String> toCapitalizedStringList(Iterable<dynamic> e) =>
    e.map((value) => toCapitalizedString(value)).toList();

EntryType toEntryType(String type) {
  return EntryType.values.firstWhere(
    (e) => e.toString().contains(type.toUpperCase()),
    orElse: () => throw EnumNotFound('EntryType of type $type does not exist'),
  );
}
