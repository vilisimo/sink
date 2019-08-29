import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  final String error;

  FormError(this.error);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        "$error",
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.red),
      ),
    );
  }
}
