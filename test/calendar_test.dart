import 'package:intl/intl.dart';
import 'package:sink/common/calendar.dart';
import 'package:sink/common/exceptions.dart';
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

  group("datetime to zeroth hour", () {
    test("converts datetime to zeroth hour of that day", () {
      final date = DateTime.now();

      var zeroth = startOfDay(date);

      expect(zeroth.year, equals(date.year));
      expect(zeroth.month, equals(date.month));
      expect(zeroth.day, equals(date.day));
      expect(zeroth.hour, equals(0));
      expect(zeroth.minute, equals(0));
      expect(zeroth.second, equals(0));
    });

    test("converts almost midnight to zeroth hour of that day", () {
      final date = DateTime(2000, 1, 1, 23, 59, 59, 999);

      var zeroth = startOfDay(date);

      expect(zeroth.year, equals(date.year));
      expect(zeroth.month, equals(date.month));
      expect(zeroth.day, equals(date.day));
      expect(zeroth.hour, equals(0));
      expect(zeroth.minute, equals(0));
      expect(zeroth.second, equals(0));
    });

    test("converts slightly over midnight to zeroth hour of that day", () {
      final date = DateTime(2000, 1, 1, 0, 0, 0, 0, 1);

      var zeroth = startOfDay(date);

      expect(zeroth.year, equals(date.year));
      expect(zeroth.month, equals(date.month));
      expect(zeroth.day, equals(date.day));
      expect(zeroth.hour, equals(0));
      expect(zeroth.minute, equals(0));
      expect(zeroth.second, equals(0));
    });

    test("calculates range between two dates", () {
      var start = DateTime(2000, 1);
      var end = DateTime(2000, 3);

      var result = dateRange(start, end);

      expect(result, [DateTime(2000, 3), DateTime(2000, 2), DateTime(2000, 1)]);
    });

    test("calculates range between two non starting dates", () {
      var start = DateTime(2000, 1, 15);
      var end = DateTime(2000, 3, 13);

      var result = dateRange(start, end);

      expect(result, [DateTime(2000, 3), DateTime(2000, 2), DateTime(2000, 1)]);
    });

    test("calculates range of one date when between two same month dates", () {
      var start = DateTime(2000, 1, 15);
      var end = DateTime(2000, 1, 18);

      var result = dateRange(start, end);

      expect(result, [DateTime(2000, 1)]);
    });

    test("does not allow 'from' to be greater than 'to'", () {
      expect(
        () => dateRange(DateTime(2000, 2), DateTime(2000, 1)),
        throwsA(TypeMatcher<InvalidInput>()),
      );
    });
  });
}
