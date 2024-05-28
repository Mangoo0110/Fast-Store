import 'package:intl/intl.dart';

class UtcDateTime {
  DateTime _dateTime;
  UtcDateTime({required DateTime dateTime}): _dateTime = dateTime.toUtc() ;

  DateTime get utcDateTime => _dateTime.toUtc();

  String get utcDateString => DateFormat.yMMMMd().format(_dateTime);

  DateTime get utcDateOnly => DateTime(_dateTime.year, _dateTime.month, _dateTime.day);

  factory UtcDateTime.parse(String formattedString) {
    return UtcDateTime(dateTime: DateTime.parse(formattedString));
  }

}