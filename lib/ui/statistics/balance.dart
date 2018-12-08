import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/repository/firestore_calculator.dart';
import 'package:sink/ui/common/progress_indicator.dart';

class BalanceCard extends StatelessWidget {
  final DateTime from;
  final DateTime to;

  BalanceCard({@required this.from, @required this.to});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreRepository.snapshotBetween(from, to),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return PaddedCircularProgressIndicator();
          }

          double income = 1500.0;
          double expenses = totalCost(snapshot.data.documents);
          double balance = income - expenses;

          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                summary("Income", income),
                summary("Expenses", expenses),
                summary("Balance", balance),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget summary(String text, double amount) => Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(amount.toStringAsFixed(2)),
        ],
      ),
    );