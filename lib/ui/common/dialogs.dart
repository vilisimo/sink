import 'package:flutter/material.dart';
import 'package:sink/theme/palette.dart' as Palette;

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String confirmationText;
  final String proceedText;
  final String cancelText;

  final Color proceedColor;
  final Color cancelColor;

  final Function onProceed;
  final Function onCancel;

  ConfirmationDialog({
    @required this.title,
    @required this.confirmationText,
    @required this.proceedText,
    @required this.cancelText,
    @required this.onProceed,
    @required this.onCancel,
    proceedColor,
    cancelColor,
  })  : this.proceedColor = proceedColor ?? Palette.discouraged,
        this.cancelColor = cancelColor ?? Palette.dimBlueGrey;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      content: Text(
        confirmationText,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subhead,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
          child: FlatButton(
            child: Text(cancelText),
            textColor: Colors.white,
            color: cancelColor,
            onPressed: () => onCancel(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
          child: FlatButton(
            child: Text(proceedText),
            textColor: Colors.white,
            color: proceedColor,
            onPressed: () => onProceed(),
          ),
        ),
      ],
    );
  }
}
