import 'package:quiver/strings.dart';
import 'package:sink/common/exceptions.dart';

notEmpty(String value) {
  if (isBlank(value)) {
    throw InvalidInput('Field cannot be empty');
  }
}

nonNegative(String value) {
  notEmpty(value);

  if (double.parse(value) <= 0) {
    throw InvalidInput('Value must be non-negative');
  }
}
