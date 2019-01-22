import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> removed;
  final List<String> categories = [
    "Food",
    "Clothes",
    "Sweets",
    "Bills",
    "PC",
    "Car",
    "Travel",
  ];

  AppState({removed}) : this.removed = removed ?? List();

  AppState copyWith({List<Entry> removed}) {
    return AppState(
      removed: removed ?? this.removed,
    );
  }
}
