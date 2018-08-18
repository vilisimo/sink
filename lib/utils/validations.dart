import 'package:sink/exceptions/InvalidInput.dart';

notEmpty(String value) {
  if (value == null || value.trim().isEmpty) {
    throw InvalidInput('Field cannot be empty');
  }
}

nonNegative(String value) {
  notEmpty(value);

  if (double.parse(value) <= 0) {
    throw InvalidInput('Value must be non-negative');
  }
}