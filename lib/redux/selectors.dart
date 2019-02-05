import 'package:flutter/material.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/state.dart';

Entry getLastRemoved(AppState state) => state.removed.last;
Set<Category> getCategories(AppState state) => state.categories;
Set<Color> getUsedColors(AppState state) =>
    state.categories.map((category) => category.color).toSet();
