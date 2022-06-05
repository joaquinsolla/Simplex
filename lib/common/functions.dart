import 'package:intl/intl.dart';

String monthConversor(DateTime date){

  List months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];

  return (months[date.month-1]);
}

String datetimeToString(DateTime dateTime){
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String stringDateToYMD(String date){
  String reversedDate = date.substring(6) + '-' +
  date.substring(3, 5) + '-' +
  date.substring(0, 2);

  return reversedDate;
}