import 'package:intl/intl.dart';

class NumberFormatter {
  static String format(num number) {

    if(number >= 1000000000){
      double value = number / 1000000000;
      return "${_removeTrailingZeros(value)}B";
    } else if (number >= 1000000) {
      double value = number / 1000000;
      return "${_removeTrailingZeros(value)}M";
    } else if (number >= 1000) {
      double value = number / 1000;
      return "${_removeTrailingZeros(value)}K";
    } else {
      return number.toString();
    }
  }

  static String _removeTrailingZeros(double value) {
    String text = value.toStringAsFixed(2); // keep 2 decimals max
    text = text.replaceAll(RegExp(r'0+$'), '');
    text = text.replaceAll(RegExp(r'\.$'), '');
    return text;
  }
}

