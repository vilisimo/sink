import 'package:flutter/material.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';
import 'package:sink/redux/state.dart';

Entry getLastRemoved(AppState state) => state.removed.last;
Set<Category> getCategories(AppState state) => state.categories;
Set<Color> getUsedColors(AppState state) =>
    state.categories.map((category) => category.color).toSet();
Category getCategory(AppState state, String id) =>
    state.categories.firstWhere((category) {
      return category.id == id;
    }, orElse: () {
      // TODO: what to do in a case where retrieval of categories fails, but
      //  retrieval of entries does not?
      throw "Could not find a category with id[$id]";
    });
