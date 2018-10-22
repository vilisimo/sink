import 'package:intl/intl.dart';
import 'package:sink/utils/calendar.dart';
import 'package:test/test.dart';

void main() {

  group("current month's name", () {
    test("name matches current month", () {
      final actual = currentMonth();
      final expected = DateFormat.MMMM().format(DateTime.now());

      expect(expected, equals(actual));
    });
  });

  group("current month's first day", () {
    test("retrieves first day of a current month", () {
      final now = DateTime.now();
      final actual = currentFirst();
      final expected = DateTime(now.year, now.month, 1);

      expect(expected, actual);
    });
  });

  group("current month's last day", () {
    test("retrieves last day of a current month", () {
      final now = DateTime.now();
      final actual = currentLast();
      final expected = DateTime(now.year, now.month + 1, 0);

      expect(expected, actual);
    });
  });

  group("month's name", () {
    test("resolves month's name", () {
      final name = monthsName(DateTime(2018, 10, 01));

      expect(name, "October");
    });
  });

  group("first day", () {
    test("returns first day of a month", () {
      final date = firstDay(DateTime(2018, 10, 10));

      expect(date, equals(DateTime(2018, 10, 1)));
    });
  });

  group("last day", () {
    test("returns last day of a month", () {
      final date = lastDay(DateTime(2018, 10, 10));

      expect(date, equals(DateTime(2018, 10, 31)));
    });

    test("returns last day when month's first day is given", () {
      final date = lastDay(DateTime(2018, 12, 01));

      expect(date, equals(DateTime(2018, 12, 31)));
    });

    test("returns last day of a february", () {
      final date = lastDay(DateTime(2020, 02, 01));

      expect(date, equals(DateTime(2020, 02, 29)));
    });
  });
}