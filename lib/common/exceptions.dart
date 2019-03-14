class InvalidInput implements Exception {
  String cause;

  InvalidInput(this.cause);
}

class CategoryNotFound implements Exception {
  String cause;

  CategoryNotFound(this.cause);
}

class EnumNotFound implements Exception {
  String cause;

  EnumNotFound(this.cause);
}
