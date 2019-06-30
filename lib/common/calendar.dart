import 'package:intl/intl.dart';
import 'package:sink/common/exceptions.dart';

String currentMonth() => monthsName(DateTime.now());

DateTime currentFirst() => firstDay(DateTime.now());

DateTime currentLast() => lastDay(DateTime.now());

String monthsName(DateTime month) => DateFormat.MMMM().format(month);

DateTime firstDay(DateTime date) => DateTime(date.year, date.month, 1);

DateTime lastDay(DateTime date) => DateTime(date.year, date.month + 1, 0);

DateTime startOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);

List<DateTime> dateRange(DateTime from, DateTime to) {
  if (from.isAfter(to)) {
    throw InvalidInput("'from'[=$from] must come after 'to'[=$to]");
  }

  var start = DateTime(from.year, from.month);
  var end = DateTime(to.year, to.month);

  List<DateTime> result = [end];
  var currentMonth = 1;
  while (start != end) {
    end = DateTime(to.year, to.month - currentMonth++);
    result.add(end);
  }
  return result;
}
