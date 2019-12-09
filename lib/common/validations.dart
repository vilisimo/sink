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

validatePassword(String password) {
  if (password.isEmpty) {
    return "Password field cannot be empty";
  } else if (password.length < 6) {
    return "Password should contain at least 6 symbols";
  }
  return null;
}
