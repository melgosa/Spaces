import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:monitor_ia/src/utils/constants_utils.dart';
import 'package:intl/date_symbol_data_local.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
  showDialog(
    barrierColor: Color.fromRGBO(255, 27, 0, 0.7),
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text(titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(mensaje == null ? '' : mensaje),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                  child: Image.asset('assets/img/error_generic.png',
                      height: 100,
                      width: 100)
              )
            ],
          ),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Entendido')),
          ],
        );
      });

}

String dayOfWeek(int timeStamp){
  initializeDateFormatting('es');
  return timeStamp != null
      ? DateFormat.E('es').format(DateTime.fromMillisecondsSinceEpoch(timeStamp)).toUpperCase()
      : 'S/F';


}

String shortDate(int timeStamp){
  return timeStamp != null
      //? DateFormat('dd-MM').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
      ? DateFormat.MMMd('es').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
      : 'S/F';
}

/*String normalDate(int timeStamp){
  return timeStamp != null
      ? DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
      : 'S/F';
}*/

String normalDateWithTimeStamp(int timeStamp){
  return timeStamp != null
      ? DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
      : 'S/F';
}

String normalDate(String date){
  return date != null
      ? DateFormat('dd-MM-yyyy').format(DateTime.parse(date))
      : 'S/F';
}

String normalDateBegginByYear(DateTime dateTime){
  return DateFormat('yyyy-MM-dd').format(dateTime).toString();
}

String schedule(int timeStamp){
  return timeStamp != null
      ? DateFormat.Hm('es').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
      : 'S/F';
}

String scheduleHHmm(int timeStamp){
  return timeStamp != null
      ? DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
      : 'S/F';
}

String scheduleHHmmByDateTime(DateTime dateTime){
  return DateFormat('HH:mm').format(dateTime).toString();
}

int getJustHour(int timeStamp){
  return DateTime.fromMillisecondsSinceEpoch(timeStamp).hour;
}



