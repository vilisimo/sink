import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sink/models/entry.dart';

class EntryItem extends StatelessWidget {
  final Entry entry;

  EntryItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    entry.category.toString(),
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          entry.description.toString(),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            DateFormat.yMMMMEEEEd().format(entry.date),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "${entry.cost} €",
                      style: TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
