import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(Sink());

class Sink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
