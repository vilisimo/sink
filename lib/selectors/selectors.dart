import 'package:sink/models/entry.dart';
import 'package:sink/models/state.dart';

Entry getLastRemoved(AppState state) => state.removed.last;
