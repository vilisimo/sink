import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

/// Entries

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

  DeleteEntry(this.entry);
}

@immutable
class UndoDelete {}

/// Categories

@immutable
class InitState {}

@immutable
class LoadCategories {
  final Set<String> categories;

  LoadCategories(this.categories);
}

@immutable
class CreateCategory {
  final String category;

  CreateCategory(this.category);
}
