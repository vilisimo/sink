import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> removed;
  //TODO: proper classes with ids?
  final Set<String> categories;

  AppState({removed, categories})
      : this.removed = removed ?? List(),
        this.categories = categories ?? Set();

  AppState copyWith({
    List<Entry> removed,
    Set<String> categories,
  }) {
    return AppState(
      removed: removed ?? this.removed,
      categories: categories ?? this.categories,
    );
  }
}
