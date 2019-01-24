import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> removed;
  //TODO: proper classes with ids?
  final List<String> categories;

  AppState({removed, categories})
      : this.removed = removed ?? List(),
        this.categories = categories ?? List();

  AppState copyWith({List<Entry> removed, List<String> categories}) {
    return AppState(
      removed: removed ?? this.removed,
      categories: categories ?? this.categories,
    );
  }
}
