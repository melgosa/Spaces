import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monitor_ia/src/utils/utils.dart';

class WorkAreasBooked {
  List<WorkAreaBooked> items = [];

  WorkAreasBooked();

  WorkAreasBooked.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final workAreaBooked = new WorkAreaBooked.fromJson(item);
      items.add(workAreaBooked);
    }
  }
}

class WorkAreaBooked {
  WorkAreaBooked({
    this.hora,
    this.idVenue,
    this.idWorkArea,
    this.idRoomSeat,
    this.nameRoomSeat,
    this.nameWa,
    this.bookings,
    this.tipo,
  });

  int hora;
  int idVenue;
  int idWorkArea;
  int idRoomSeat;
  String nameRoomSeat;
  String nameWa;
  List<Booking> bookings;
  int tipo;

  factory WorkAreaBooked.fromJson(Map<String, dynamic> json) => WorkAreaBooked(
    hora: json["hora"],
    idVenue: json["idVenue"],
    idWorkArea: json["idWorkArea"],
    idRoomSeat: json["idRoomSeat"],
    nameRoomSeat: json["nameRoomSeat"],
    nameWa: json["nameWA"],
    bookings: json["bookingListRespObj"] == null ?  List<Booking>.from([].map((x) => Booking.fromJson(x))) : List<Booking>.from(json["bookingListRespObj"].map((x) => Booking.fromJson(x))),
    tipo: json["tipo"],
  );

  Map<String, dynamic> toJson() => {
    "hora": hora,
    "idVenue": idVenue,
    "idWorkArea": idWorkArea,
    "idRoomSeat": idRoomSeat,
    "nameRoomSeat": nameRoomSeat,
    "nameWA": nameWa,
    "bookingListRespObj": List<dynamic>.from(bookings.map((x) => x.toJson())),
    "tipo": tipo,
  };


}

class Booking {
  Booking({
    this.idReserv,
    this.bookingDateTimeStart,
    this.bookingDateTimeEnd,
    this.available,
  });

  int idReserv;
  int bookingDateTimeStart;
  int bookingDateTimeEnd;
  bool available;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    idReserv: json["idReserv"] == null ? 0 : json["idReserv"],
    bookingDateTimeStart: getJustHour(json["bookingDateTimeStart"]),
    bookingDateTimeEnd: json["bookingDateTimeEnd"],
    available: json["available"],
  );

  Map<String, dynamic> toJson() => {
    "idReserv": idReserv,
    "bookingDateTimeStart": bookingDateTimeStart,
    "bookingDateTimeEnd": bookingDateTimeEnd,
    "available": available,
  };
}

/*class Schedule{
  static const DISPONIBLE = "disponible";
  static const OCUPADO = "ocupado";

  static List<Schedule> schedules(String fecha){
    List<Schedule> schedulesTemp = [];

    for(int i = 8; i < 20; i++){
      Schedule schedule = new Schedule();
      schedule.idHorario = i;
      if(i < 10)
        schedule.horarioAMostrar = '0$i:00:00 a ${i+1 < 10 ? '0${i+1}' : '${i+1}'}:00:00';
      else
        schedule.horarioAMostrar = '$i:00:00 a ${i+1}:00:00';
      if(i < 10){
        schedule.dateTimeInit = DateTime.parse('$fecha 0$i:00:01').toUtc();
        schedule.dateTimeEnd = DateTime.parse('$fecha ${i+1 < 10 ? '0${i+1}' : '10'}:00:00').toUtc();
      }else{
        schedule.dateTimeInit = DateTime.parse('$fecha $i:00:01').toUtc();
        schedule.dateTimeEnd = DateTime.parse('$fecha ${i+1}:00:00').toUtc();
      }
      schedulesTemp.add(schedule);
    }
    return schedulesTemp;
  }

  int idHorario;
  String horarioAMostrar;
  Color backgroundColor;
  String status;
  DateTime dateTimeInit;
  DateTime dateTimeEnd;
  String fecha;

  Schedule({
    this.idHorario,
    this.horarioAMostrar,
    this.backgroundColor = Colors.white,
    this.status = DISPONIBLE,
    this.dateTimeInit,
    this.dateTimeEnd,
    this.fecha = '2021-05-14'
  });

}*/

class Schedule {
  int id;
  String hourToShow;
  String hourToSend;

  Schedule({this.id, this.hourToShow, this.hourToSend});

  static List<Schedule> schedules(int startTimeid, int offset) {
    List<Schedule> schedulesTemp = [];

    for (int i = startTimeid; i < (21 + offset); i++) {
      Schedule schedule = new Schedule();
      schedule.id = i;
      if (i < 10) {
        schedule.hourToShow = '0$i:00';
        if(offset == 0)
          schedule.hourToSend = '0$i:00:01';
        else
          schedule.hourToSend = '0$i:00:00';
      } else {
        schedule.hourToShow = '$i:00';
        if(offset == 0)
          schedule.hourToSend = '$i:00:01';
        else
          schedule.hourToSend = '$i:00:00';
      }
      schedulesTemp.add(schedule);
    }

    return schedulesTemp;
  }
}
