import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, {String format = 'dd-MM-yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateForDisplay(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime? parseDate(
    String dateString, {
    String format = 'yyyy-MM-dd',
  }) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }
}
