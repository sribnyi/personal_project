import 'package:intl/intl.dart';

class DateTimeFormat {
  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy, HH:mm');
    final formattedString = formatter.format(date);
    final dateString = formattedString.split(', ').sublist(0, 2).join(', ');
    final timeString = formattedString.split(', ').last;
    return '$dateString, $timeString';
  }
}