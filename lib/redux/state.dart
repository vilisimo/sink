import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> removed;

  AppState({removed}) : this.removed = removed ?? List();

  AppState copyWith({List<Entry> removed}) {
    return AppState(
      removed: removed ?? this.removed,
    );
  }
}
