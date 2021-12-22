import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';

class MyReservations {
  List<MyReservation> items = List();

  MyReservations();

  MyReservations.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final myReservation = new MyReservation.fromJson(item);
      items.add(myReservation);
    }
  }
}

class MyReservation {
  static const NO_INICIADA = 0;
  static const EN_PROCESO = 1;
  static const FINALIZADA = 2;

  static const ESCRITORIO = 'Escritorio';
  static const ASIENTO = 'Asiento';
  static const SALA = 'Sala';
  static const SALA_DE_JUNTAS = 'Sala de Juntas';
  static const COMEDOR = 'Comedor';
  static const AREA_FUMAR = 'Area de fumar';

  final dataProvider = new B2WProvider();


  MyReservation({
    this.idUser,
    this.idReservation,
    this.description,
    this.startDate,
    this.endDate,
    this.idAsientoSala,
    this.nameAsientoSala,
    this.idWaVenue,
    this.checkin,
    this.checkout,
  });

  int idUser;
  int idReservation;
  String description;
  int startDate;
  int endDate;
  int idAsientoSala;
  String nameAsientoSala;
  int idWaVenue;
  int checkin;
  int checkout;

  factory MyReservation.fromJson(Map<String, dynamic> json) => MyReservation(
    idUser: json["idUser"],
    idReservation: json["idReservation"],
    description: json["description"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    idAsientoSala: json["idAsientoSala"],
    nameAsientoSala: json["nameAsientoSala"],
    idWaVenue: json["idWaVenue"],
    checkin: json["checkin"] == null ? null : json["checkin"],
    checkout: json["checkout"] == null ? null : json["checkout"],
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "idReservation": idReservation,
    "description": description,
    "startDate": startDate,
    "endDate": endDate,
    "idAsientoSala": idAsientoSala,
    "nameAsientoSala": nameAsientoSala,
    "idWaVenue": idWaVenue,
    "checkin": checkin == null ? null : checkin,
    "checkout": checkout == null ? null : checkout,
  };

  Color backgroundColor(){
    if(this.checkin == null){
      //No ha hecho checin en sala o escritorio
      return Colors.grey[300];
    }else{
      if(this.checkout == null){
        //Ya hizo checkin, esta en la sala o escritorio
        return Colors.yellow;
      }else{
        //Ya hizo checkout, salio la sala o escritorio
        return Colors.teal;
      }
    }
  }

  int status(){
    if(this.checkin == null){
      //No ha hecho checin en sala o escritorio
      return MyReservation.NO_INICIADA;
    }else{
      if(this.checkout == null){
        //Ya hizo checkin, esta en la sala o escritorio
        return MyReservation.EN_PROCESO;
      }else{
        //Ya hizo checkout, salio la sala o escritorio
        return MyReservation.FINALIZADA;
      }
    }
  }

  Future <String> checkIn() async {
    String result;
    if (this.description == ESCRITORIO) {
      result = await dataProvider.createSeatCheckin(this.idAsientoSala, this.idReservation, this.idUser);
    }

    if (this.description == SALA) {
      result = await dataProvider.createMeetingRoomCheckin(this.idReservation, this.idUser);
    }

    if (this.description == 'Comedor') {}

    return result;
  }

  Future <String> checkOut() async {
    String result;
    if (this.description == ESCRITORIO) {
      result = await dataProvider.createSeatCheckout(this.idAsientoSala, this.idReservation, this.idUser);
    }

    if (this.description == SALA) {
      result = await dataProvider.createMeetingRoomCheckout(this.idReservation, this.idUser);
    }

    if (this.description  == 'Comedor') {}

    return result;
  }

  Icon iconStatus(){
    return Icon(this.status() == NO_INICIADA ? Icons.calendar_today_outlined : Icons.history,
      size: 30.0,
    );
  }
}




