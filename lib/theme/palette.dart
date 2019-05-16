import 'dart:collection';

import 'package:flutter/material.dart';

var dimBlueGrey = Color(Colors.blueGrey.value).withOpacity(0.7);
var lightGrey = Color.fromRGBO(211, 211, 211, 0.7);

var income = Colors.lightGreen;
var expense = Colors.red;

final LinkedHashSet<Color> materialColors = LinkedHashSet.from(Colors.primaries)
  ..addAll(Colors.accents);
