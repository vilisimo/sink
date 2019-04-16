import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/repository/firestore_calculator.dart';
import 'package:sink/theme/palette.dart' as Palette;
import 'package:sink/ui/common/centered_text.dart';
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

          double income = totalIncome(snapshot.data.documents);
          double expenses = totalExpense(snapshot.data.documents);
          double balance = income - expenses;

          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: CenteredText(
                      text: currentMonth(),
                      fontWeight: FontWeight.bold,
                    )),
                Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    summary("Income", income),
                    summary("Expenses", expenses),
                    summary("Balance", balance),
                  ],
                ),
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
          Text(
            text,
            style: TextStyle(
              fontSize: 14.0,
              color: Palette.dimBlueGrey,
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
