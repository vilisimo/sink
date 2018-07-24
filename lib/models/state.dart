import 'package:meta/meta.dart';
import 'package:sink/models/entry.dart';

@immutable
class AppState {
  final List<Entry> entries;
  final Entry lastEntry;
  final int lastEntryIndex;

  AppState(this.entries, {this.lastEntry, this.lastEntryIndex});

  AppState copyWith(
      {List<Entry> entries, Entry lastEntry, int lastEntryIndex}) {
    return AppState(
      entries ?? this.entries,
      lastEntry: lastEntry ?? this.lastEntry,
      lastEntryIndex: lastEntryIndex ?? this.lastEntryIndex,
    );
  }
}
