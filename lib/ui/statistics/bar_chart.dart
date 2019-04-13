import 'package:flutter/material.dart';

class Bar extends StatelessWidget implements Comparable<Bar> {
  final String label;
  final double amount;
  final Color color;

  Bar({
    @required this.label,
    @required this.amount,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //TODO: largest expense = 100%; others = 100 * x (given x < 1.0);
            child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.4, //TODO: adjust bar width for category amount
              height: 20.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9.0),
                  ),
                  color: color,
                ),
              ),
            ),
          ),
          Text("$label: $amount")
        ],
      ),
    );
  }

  @override
  int compareTo(Bar other) {
    if (this.amount > other.amount) {
      return 1;
    } else if (this.amount == other.amount) {
      return 0;
    } else {
      return -1;
    }
  }
}
