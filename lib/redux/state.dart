import 'package:meta/meta.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> removed;
  final Set<Category> categories;
  // TODO: must be at least one default category
  final bool areCategoriesLoading;

  AppState({removed, categories, areCategoriesLoading})
      : this.removed = removed ?? List(),
        this.categories = categories ?? Set(),
        this.areCategoriesLoading = areCategoriesLoading ?? true;

  AppState copyWith({
    List<Entry> removed,
    Set<Category> categories,
    bool areCategoriesLoading,
  }) {
    return AppState(
      removed: removed ?? this.removed,
      categories: categories ?? this.categories,
      areCategoriesLoading: areCategoriesLoading ?? this.areCategoriesLoading,
    );
  }
}
