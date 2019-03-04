import 'package:flutter/services.dart';

class DecimalInputFormatter implements TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final validNew = isValid(next.text);

    if (validNew) {
      return next;
    } else {
      return old;
    }
  }

  // TODO: probably better handled by regex
  bool isValid(String value) {
    if (value == '') {
      return true;
    }

    if (double.tryParse(value) == null) {
      return false;
    }

    if (value.startsWith('00')) {
      return false;
    }

    if (value.contains(' ')) {
      return false;
    }

    if (value.length > 1 && value.startsWith('0') && value[1] != '.') {
      return false;
    }

    var sides = value.split('.');
    if (sides.length > 1 && sides[1].length > 2) {
      return false;
    }

    return true;
  }
}
