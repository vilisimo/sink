import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  // TODO: store entries in TreeSet?
  final List<Entry> entries;
  final List<Entry> removed;

  AppState(this.entries, {removed}) : this.removed = removed ?? List();

  AppState copyWith({List<Entry> entries, List<Entry> removed}) {
    return AppState(
      entries ?? this.entries,
      removed: removed ?? this.removed,
    );
  }
}
