import 'package:intl/intl.dart';

class AppFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'USD', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}), ${phoneNumber.substring(4, 8)}, ${phoneNumber.substring(8)}';
    } else if (phoneNumber.length == 12) {
      return '(${phoneNumber.substring(0, 5)}), ${phoneNumber.substring(5, 9)}, ${phoneNumber.substring(9)}';
    }
    return phoneNumber;
  }
}
