import 'package:sink/models/entry.dart';
import 'package:sink/redux/state.dart';

List<Entry> getEntries(AppState state) => state.entries;