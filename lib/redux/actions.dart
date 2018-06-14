import 'package:sink/domain/entry.dart';

class AddEntry {
  final Entry entry;

  AddEntry(this.entry);
}

class EditEntry {
  final Entry entry;
  final int index;

  EditEntry(this.entry, this.index);
}

class DeleteEntry {
  final Entry entry;

  DeleteEntry(this.entry);
}