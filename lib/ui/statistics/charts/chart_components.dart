import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartTitle extends StatelessWidget {
  final String title;

  ChartTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }
}

class ChartSubtitle extends StatelessWidget {
  final String subtitle;

  ChartSubtitle({@required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }
}
