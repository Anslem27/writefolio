import 'package:intl/intl.dart';

dateParser(String inputedDate) {
  String inputDate = inputedDate;
  DateTime date = DateTime.parse(inputDate);

  String formattedDate = DateFormat("d MMM y").format(date);
  //String suffix = _getNumberSuffix(date.day);
  return formattedDate;
}

/* String _getNumberSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
} */
