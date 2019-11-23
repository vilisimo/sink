import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:sink/models/category.dart';
import 'package:sink/models/entry.dart';

@immutable
class AddEntry {
  final Entry entry;

  AddEntry(this.entry);
}

@immutable
class EditEntry {
  final Entry entry;

  EditEntry(this.entry);
}

@immutable
class DeleteEntry {
  final Entry entry;

  DeleteEntry(this.entry);
}

@immutable
class UndoDelete {}

@immutable
class RehydrateState {}

@immutable
class LoadFirstEntry {}

@immutable
class LoadMonths {
  final DateTime from;
  final DateTime to;

  LoadMonths(this.from, this.to);
}

@immutable
class SelectMonth {
  final DoubleLinkedQueueEntry<DateTime> month;

  SelectMonth(this.month);
}

@immutable
class ReloadCategories {
  final Set<Category> categories;

  ReloadCategories(this.categories);
}

@immutable
class ReloadColors {
  final Set<Color> usedColors;

  ReloadColors(this.usedColors);
}

@immutable
class CreateCategory {
  final Category category;

  CreateCategory(this.category);
}

/// Sign up & log in

@immutable
class RetrieveUser {}

@immutable
class SignIn {
  final String email;
  final String password;

  SignIn({@required this.email, @required this.password});
}

@immutable
class SignOut {}

@immutable
class StartRegistration {}

@immutable
class Register {
  final String email;
  final String password;

  Register({@required this.email, @required this.password});
}

@immutable
class ReportRegistrationSuccess {}

@immutable
class ReportSignInSuccess {}

@immutable
class ReportAuthenticationError {
  final String code;

  ReportAuthenticationError(this.code);
}

@immutable
class ClearAuthenticationState {}

@immutable
class SendVerificationEmail {}

@immutable
class SetUserDetails {
  final String id;
  final String email;

  SetUserDetails({@required this.id, @required this.email});
}

@immutable
class InitializeDatabase {
  final String userId;
  final bool test;

  InitializeDatabase(this.userId, [this.test = false]);
}

@immutable
class PreSignOut {}
