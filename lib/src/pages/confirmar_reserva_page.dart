import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monitor_ia/src/models/my_reservations.dart';
import 'package:monitor_ia/src/models/venue_model.dart';
import 'package:monitor_ia/src/models/work_area_booked_model.dart';
import 'package:monitor_ia/src/models/work_area_types_model.dart';
import 'package:monitor_ia/src/pages/medidas_prevencion_page.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/utils.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/header_common_widget.dart';
import 'package:monitor_ia/src/widgets/item_reservas_programadas_widget.dart';

class ConfirmarReservaPage extends StatefulWidget {
  final WorkAreaBooked workAreaBooked;
  final WorkAreaType workAreaType;
  final Venue venue;
  final DateTime dateTimeInit;
  final DateTime dateTimeEnd;

  ConfirmarReservaPage(
      this.workAreaBooked,
      this.workAreaType,
      this.venue,
      this.dateTimeInit,
      this.dateTimeEnd,
      ) ;

  @override
  _ConfirmarReservaPageState createState() => _ConfirmarReservaPageState();
}

class _ConfirmarReservaPageState extends State<ConfirmarReservaPage> {
  static const path_asset_background = 'assets/img/sala1.png';
  static const label_reserva = 'Reserva de';
  static const label_confirmar_reservacion = 'Confirmar reservación';
  static const label_modificar = 'Modificar';
  static const label_dia = 'Día';
  static const label_hora = 'Hora';
  static const label_sede = 'Sede';
  static const label_piso = 'Piso';
  static const label_escritorio = 'Escritorio';
  static const label_sala = 'Sala';
  static const label_regresar = 'Regresar';
  static const label_reservar = 'Reservar';
  static const label_a = 'a';
  static const label_confirma_que_los_datos_sean_correctos = 'Confirma que los datos sean correctos';

  bool _isLoadingData = false;
  final dataProvider = new B2WProvider();
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX');
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
          _formulario(context),
        _showBotones()
        ],
      ),
    );
  }

  _formulario(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: <Widget>[
          //_titulo(),
          HeaderCommon(label_confirmar_reservacion),
          _info(),
          _bookTicket()
          //_botonModificar(context),
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
          label_confirma_que_los_datos_sean_correctos,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _bookTicket(){
    final bookAvailable = MyReservation(
      idUser: prefs.userId,
      idAsientoSala: widget.workAreaBooked.idRoomSeat,
      description: widget.workAreaType.name,
      idReservation: 0,//No hay en este punto un id de reservación
      nameAsientoSala: widget.workAreaBooked.nameRoomSeat,
      startDate: widget.dateTimeInit.millisecondsSinceEpoch,
      endDate: widget.dateTimeEnd.millisecondsSinceEpoch,
      idWaVenue: 0, //No importante en este punto
      checkin: 0, //No importante en este punto
      checkout: 0, //No importante en este punto
    );

    return Hero(
        tag: widget.workAreaBooked.idRoomSeat,
        child: Material(
            type: MaterialType.transparency,//Se necesita para que no aparezcan letras rojas
            child: ItemReservasProgramadas(bookAvailable, null)
        )
    );
  }

  Widget widgetsToShowFromSeatOrRoom() {
    if (widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_ASIENTO) {
      return Column(
        children: [
          datos(label_piso, widget.workAreaBooked.nameWa),
          datos(label_escritorio, widget.workAreaBooked.nameRoomSeat),
        ],
      );
    } else {
      return datos(label_sala, widget.workAreaBooked.nameRoomSeat);
    }
  }

  Widget datos(String dato, String valor){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Text(dato, style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,)
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Text(valor, style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _botonModificar(BuildContext context){
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 40),
        child: RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: Text(label_modificar),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          elevation: 0.0,
          color:  Colors.amber[600],
          textColor: Colors.white,
          onPressed: () {
            //Navigator.popUntil(context, ModalRoute.withName('busquedaWorkArea'));
          },
        ),
      ),
    );
  }

  Widget _showBotones() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            //color: Color.fromRGBO(62, 66, 107, 0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _botonCancelar(),
              SizedBox(width: 10),
              _botonContinuar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonCancelar() {
    return Expanded(
      child: RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric( vertical: 20.0),
          child: Text(label_regresar, style: TextStyle(fontSize: 20)),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.0,
        color: Color.fromRGBO(126, 128, 131, 1.0),
        textColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _botonContinuar() {
    return Expanded(
      child: RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: _isLoadingData
              ? Container(height: 20.0, width: 20.0,child: Center(child: CircularProgressIndicator()))
              : Text(label_reservar, style: TextStyle(fontSize: 20),),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.0,
        color: Color.fromRGBO(50, 112, 239, 1),
        textColor: Colors.white,
        onPressed: _isLoadingData ? null : _reservarWorkArea,
      ),
    );
  }

  _reservarWorkArea() async{
    _isLoadingData = true;
    setState(() {});
    String resp = await dataProvider.saveBooking(widget.dateTimeInit.toUtc(),
        widget.dateTimeEnd.toUtc(),
        widget.workAreaBooked.idRoomSeat,
        prefs.userId,
        widget.workAreaBooked.idVenue,
        widget.workAreaBooked.idWorkArea,
        widget.workAreaBooked.tipo
    );
    if(resp == 'OK'){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedidasPrevencionPage(widget.workAreaType.name)));
    }else{
      mostrarAlerta(context, 'Error en reserva', resp);
    }
    _isLoadingData = false;
    setState(() {});
  }
}
