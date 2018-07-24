import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AddEntry {
  final Entry entry;

  AddEntry(this.entry);
}

@immutable
class EditEntry {
  final Entry entry;

  EditEntry(this.entry);
}

@immutable
class DeleteEntry {
  final Entry entry;
  final int index;

  DeleteEntry(this.entry, this.index);
}

@immutable
class UndoDelete {}