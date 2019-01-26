import 'package:flutter/material.dart';

class CategoryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('New Category'),
        actions: <Widget>[
          IconButton(
            iconSize: 28.0,
            icon: Icon(Icons.check),
            onPressed: () {
              print("Saved a category!");
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Text("Not yet implemented"),
    );
  }
}
