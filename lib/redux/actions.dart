import 'package:meta/meta.dart';
import 'package:sink/domain/entry.dart';

@immutable
class AddEntry {
  final Entry entry;

  AddEntry(this.entry);
}

@immutable
class EditEntry {
  final Entry entry;
  final int index;

  EditEntry(this.entry, this.index);
}

@immutable
class DeleteEntry {
  final Entry entry;

  DeleteEntry(this.entry);
}