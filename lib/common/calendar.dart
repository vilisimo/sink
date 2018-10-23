import 'package:intl/intl.dart';

String currentMonth() => monthsName(DateTime.now());

DateTime currentFirst() => firstDay(DateTime.now());

DateTime currentLast() => lastDay(DateTime.now());


String monthsName(DateTime month) => DateFormat.MMMM().format(month);

DateTime firstDay(DateTime date) => DateTime(date.year, date.month, 1);

DateTime lastDay(DateTime date) => DateTime(date.year, date.month + 1, 0);
