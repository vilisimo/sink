import 'package:sink/exceptions/InvalidInput.dart';

notEmpty(String value) {
  if (value == null || value.trim().isEmpty) {
    throw new InvalidInput('Field cannot be empty');
  }
}