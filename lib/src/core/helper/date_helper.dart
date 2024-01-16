//import intl
import 'package:intl/intl.dart';

class DateHelper {
  static String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // get month name and year
  static String getMonthNameAndYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static int getNbWeekInYear(int year) {
    DateTime date = DateTime(year, 12, 31);
    int dayOfYear = getDayOfYear(date);
    int nbWeek = dayOfYear ~/ 7;
    return nbWeek;
  }

  static getDayOfYear(DateTime date) {
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    int dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    return dayOfYear;
  }

  static int getNbDaysInYear(int year) {
    return year % 4 == 0 ? 366 : 365;
  }

  // method to get day in letter (ex: SUnday ==> Sun)
  static String getDayInLetter(DateTime date) {
    return DateFormat('E').format(date);
  }
}
