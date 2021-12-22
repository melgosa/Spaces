import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/models/my_reservations.dart';
import 'package:monitor_ia/src/models/venue_model.dart';
import 'package:monitor_ia/src/models/work_area_booked_model.dart';
import 'package:monitor_ia/src/models/work_area_types_model.dart';
import 'package:monitor_ia/src/pages/confirmar_reserva_page.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/header_common_widget.dart';
import 'package:monitor_ia/src/widgets/item_reservas_programadas_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const String label_saltar = 'Saltar';
const String label_titulo_kb0 = 'Resultados de búsqueda';
const String label_mensaje_kb0 = 'De acuerdo a los parámetros ingresados en la pantalla anterior, aquí se muestran todos los espacios disponibles que cumplen con esos criterios para tu selección. Escoge el que mejor te convenga.\n\nToca para terminar el recorrido en esta pantalla';


class ReservaWorkAreaPage extends StatefulWidget {
  final List<WorkAreaBooked> workAreasBooked;
  final WorkAreaType workAreaType;
  final Venue venue;
  final DateTime dateTimeInit;
  final DateTime dateTimeEnd;

  ReservaWorkAreaPage(this.workAreasBooked, this.workAreaType, this.venue, this.dateTimeInit, this.dateTimeEnd, {Key key}) : super(key: key);

  @override
  _ReservaWorkAreaPageState createState() => _ReservaWorkAreaPageState();
}

class _ReservaWorkAreaPageState extends State<ReservaWorkAreaPage> {
  static const label_no_hay_datos = 'No hay datos a mostrar';
  static const label_toca_la_reserva = 'Toca la reserva que deseas';
  static const label_estos_son_los_resultados = 'Estos son los resultados disponibles de acuerdo con los parámetros de tu búsqueda';

  final prefs = new PreferenciasUsuario();

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyButton0 = GlobalKey();

  @override
  void initState() {
    super.initState();
    if(prefs.firstTutReservas) {
      initTargets();
      showTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
              Colors.blue[700],
              Colors.blueAccent[100],
              HexColor('#0B1467'),
              HexColor('#182FF7')
          ),
          _formulario(context)
        ],
      ),
    );
  }

  Widget _formulario(BuildContext context){
    return Container(
      child: Column(
        children: [
          HeaderCommon(label_toca_la_reserva),
          _info(),
          widget.workAreasBooked == null
              ? Center(child: CircularProgressIndicator())
              : _listaWorkAreasDisponibles()
        ],
      ),
    );
  }

  Widget _info(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label_estos_son_los_resultados,
          key: keyButton0,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _listaWorkAreasDisponibles(){
    return  widget.workAreasBooked.isNotEmpty
        ? Expanded(child: ListView( children: _listaItemsWorkAreasDisponibles(widget.workAreasBooked, context),),)
        : Text(label_no_hay_datos, style: TextStyle(fontSize: 30, color: Colors.white),);

  }

  List<Widget> _listaItemsWorkAreasDisponibles(
      List<WorkAreaBooked> workAreasDisponibles,
      BuildContext context
      ){
    final List<Widget> tickets = [];

    workAreasDisponibles.forEach((element) {

      final bookAvailable = MyReservation(
        idUser: prefs.userId,
        idAsientoSala: element.idRoomSeat,
        description: widget.workAreaType.name,
        idReservation: 0,//No hay en este punto un id de reservación
        nameAsientoSala: element.nameRoomSeat,
        startDate: widget.dateTimeInit.millisecondsSinceEpoch,
        endDate: widget.dateTimeEnd.millisecondsSinceEpoch,
        idWaVenue: 0, //No importante en este punto
        checkin: 0, //No importante en este punto
        checkout: 0, //No importante en este punto
      );

      final widgetTemp = Hero(tag: element.idRoomSeat,//element.idRoomSeat,
      child:  Material(
          type: MaterialType.transparency,//Se necesita para que no aparezcan letras rojas
          child: ItemReservasProgramadas(bookAvailable, () => _goNextPage(element))
      ));
     

      tickets..add(widgetTemp);
    });

    return tickets;
  }

  _goNextPage(WorkAreaBooked workAreaDisponible){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmarReservaPage(
            workAreaDisponible,
            widget.workAreaType,
            widget.venue,
            widget.dateTimeInit,
            widget.dateTimeEnd
        ))
    );
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton0,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label_titulo_kb0,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      label_mensaje_kb0,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: label_saltar,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        prefs.firstTutReservas = false;
      },
      onClickTarget: (target) {
        prefs.firstTutReservas = false;
      },
      onSkip: () {
        prefs.firstTutReservas = false;
      },
      onClickOverlay: (target) {
        prefs.firstTutReservas = false;
      },
    )..show();
  }
}
