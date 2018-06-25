import 'package:meta/meta.dart';
import 'package:sink/domain/entry.dart';

@immutable
class AppState {
  final List<Entry> entries;
  final Entry lastEntry;
  final int lastEntryIndex;

  AppState(this.entries, {this.lastEntry, this.lastEntryIndex});

  static AppState copyWith({List<Entry> entries, Entry lastEntry, int index}) {
    return AppState(
      entries ?? new List<Entry>(),
      lastEntry: lastEntry ?? null,
      lastEntryIndex: index ?? null,
    );
  }
}