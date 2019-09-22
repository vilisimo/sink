import 'package:flutter/material.dart';

var dimBlueGrey = Color(Colors.blueGrey.value).withOpacity(0.7);
var lightGrey = Color.fromRGBO(211, 211, 211, 0.7);

var income = Colors.lightGreen;
var expense = Colors.red;

var disabled = Color.fromRGBO(90, 90, 90, .4);
var discouraged = Color.fromRGBO(220, 20, 60, 1);

/// Uses plain [Color] instances, as material colors mess up with equality.
final Set<Color> materialColors = Set.from(
    Colors.primaries.map((c) => Color.fromRGBO(c.red, c.green, c.blue, 1.0)))
  ..addAll(
      Colors.accents.map((c) => Color.fromRGBO(c.red, c.green, c.blue, 1.0)));
