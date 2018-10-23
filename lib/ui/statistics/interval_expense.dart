import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/repository/firestore.dart';
import 'package:sink/repository/firestore_calculator.dart';
import 'package:sink/ui/common/centered_text.dart';

class IntervalExpense extends StatelessWidget {
  final DateTime from;
  final DateTime to;

  IntervalExpense({@required this.from, @required this.to});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirestoreRepository.snapshotBetween(from, to),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            double total = totalCost(snapshot.data.documents);

            return ListTile(
              title: CenteredText(
                text: (currentMonth() + " damage:").toUpperCase(),
                fontWeight: FontWeight.bold,
              ),
              subtitle: CenteredText(
                text: total.toStringAsFixed(2),
                fontSize: 28.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
