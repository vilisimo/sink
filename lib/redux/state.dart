import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> removed;
  //TODO: proper classes with ids?
  final List<String> categories;
  final String chosenCategory;

  AppState({removed, categories, chosenCategory})
      : this.removed = removed ?? List(),
        this.categories = categories ?? List(),
        this.chosenCategory = chosenCategory ?? null;

  AppState copyWith({
    List<Entry> removed,
    List<String> categories,
    String chosenCategory,
  }) {
    return AppState(
      removed: removed ?? this.removed,
      categories: categories ?? this.categories,
      chosenCategory: chosenCategory ?? this.chosenCategory,
    );
  }
}
