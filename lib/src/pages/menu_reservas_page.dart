import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:monitor_ia/src/models/meeting_room_controller_model.dart';
import 'package:monitor_ia/src/models/my_reservations.dart';
import 'package:monitor_ia/src/models/reserva_model.dart';
import 'package:monitor_ia/src/models/seat_model.dart';
import 'package:monitor_ia/src/models/work_area_types_model.dart';
import 'package:monitor_ia/src/pages/busqueda_work_area_page.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/utils.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/item_reservas_programadas_widget.dart';
import 'package:monitor_ia/src/widgets/photo_app_bar_widget.dart';
import 'package:monitor_ia/src/widgets/reserva_info_custom_dialog_widget.dart';
import 'package:monitor_ia/src/widgets/snack_message_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const String img_url_escritorio = 'https://back2work-resources.s3-us-west-2.amazonaws.com/images/escritorio.png';
const String img_url_sala_de_juntas = 'https://back2work-resources.s3-us-west-2.amazonaws.com/images/reunion.png';
const String img_asseth_image_loading = 'assets/jar-loading.gif';

const String saltar = "SALTAR";
const String cancelar = "Cancelar";
const String reserva_area_de_trabajo = 'Reserva área de trabajo';
const String mis_reservas = 'Mis reservas';
const String path_asset_image = 'assets/img/meeting_room.png';
const String autodiagnostico_monitor_al_dia = 'Autodiagnóstico al día';
const String escanear_qr ='Escanear QR';
const String error_al_obtener_informacion = 'Error al obtener información';
const String la_informacion_contenida_en_este_qr = 'La información contenida en este código QR no pertenece a un área de trabajo';
const String asiento = 'Asiento';
const String sala_de_juntas = 'Sala de Juntas';
const String que_deseas_hacer = '¿Qué deseas hacer?';
const String reservar = 'Reservar';
const String chekin ='ChekIn';
const String sin_reservas_activas = 'Sin reservas activas';
const String no_se_puede_generar_chekin ='No se puede generar checkin ya que el área de trabajo no tiene alguna reserva activa asignada a ti';
const String no_se_puede_generar_chekout ='No se puede generar checkout ya que no tienes una reserva de espacio en progreso';
const String no_existen_datos = 'No existen datos';
const String no_existen_reservas_de_sala = 'No existen reservas de sala activas donde puedas realizar tu checkin para el horario de';
const String a = 'a';
const String verifica_la_hora_de_tu_junta = ', verifica la hora de tu junta';
const String la_solicitud_se_realizo_de_manera_correcta = 'La solicitud se realizó de manera correcta';
const String chekin_erroneo = 'CheckIn erróneo';
const String no_hay_datos_a_mostrar = 'No hay datos a mostrar';
const String reserva_de = 'Reserva de';
const String dia = 'Día';
const String hora = 'Hora';
const String chekin_aun_no_disponible = 'CheckIn aun no disponible';
const String checkout_erroneo = 'CheckOut erróneo';
const String chekout = 'CheckOut';
const String puedes_escanear_los_codigos_qr = "Puedes escanear los códigos QR que se encuentran en escritorios o salas de juntas para poder reservar o hacer checkIn";
const String reservar_area_de_trabajo = "Reservar área de trabajo";
const String puedes_reservar_area_de_trabajo = "Puedes reservar un área de trabajo de forma remota";
const String puedes_visualizar_una_lista_de_reservas = "Puedes visualizar una lista de reservas de áreas de trabajo en el cual se muestra el día y horario que asignaste, al darle click puedes ver un pequeño detalle y hacer chekIn";
const String label_reservas = 'Reservas';
const String label_reservas_subtitle = 'Reserva un área de trabajo, como un escritorio, sala de juntas, comedor o incluso un lugar en el área para fumar';
const String label_areas_de_trabajo = 'Áreas de trabajo';
const String label_ocurrio_un_error = 'Ocurrió un error';
const String label_todo_bien = '¡Todo bien!';
const String label_checkout = 'Checkout';

const String label_saltar = 'Saltar';
const String label_titulo_kb0 = 'Escanear QR de espacio';
const String label_mensaje_kb0 = 'Toca este botón para activar la cámara del dispositivo y poder escanear el código QR asociado al espacio que deseas Reservar/Registrar entrada o salida\n\nToca para continuar el recorrido';
const String label_titulo_kb1 = 'Espacios disponibles para reservar';
const String label_mensaje_kb1 = 'En este listado podrás seleccionar el espacio que deseas reservar; puede ser un escritorio, sala de juntas o inclusive un lugar de estacionamiento o comedor si estan habilitados. Basta con tocar el elemento que deseas y seguir las indicaciones\n\nToca para continuar el recorrido';
const String label_titulo_kb2 = 'Tus reservas guardadas';
const String label_mensaje_kb2 = 'Aquí encontraras un listado de las reservas de espacios que tengas programadas. La lista va creciendo a medida que registres tus reservas ya sea escaneando código QR o ingresando la reserva de manera manual en las opciones arriba disponibles\n\nToca para finalizar el recorrido en esta pantalla';

class MenuReservas extends StatefulWidget {
  @override
  _MenuReservasState createState() => _MenuReservasState();
}

class _MenuReservasState extends State<MenuReservas> {
  ScrollController _scrollController = ScrollController();
  bool closeTopContainer = false;
  double _topContainer = 0;

  String _scanBarcode = 'Unknown';
  String sala;
  String capacidad;
  String equipo;
  String piso;
  final key = new GlobalKey<ScaffoldState>();

  final dataProvider = new B2WProvider();
  List<MyReservation> _myReservations;
  List<WorkAreaType> _workAreaTypes;

  bool _isLoadingData = false;

  final prefs = new PreferenciasUsuario();

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton0 = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_MX');
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAlldata();

      double value = 0;
      _scrollController.addListener(() {
        value = _scrollController.offset/300;

        setState(() {
          _topContainer = value;
          closeTopContainer = _scrollController.offset > 250;
        });
      });
    });
  }

  _getAlldata() async{
/*    final disponibles = await dataProvider.getVenueAvailable(1);
    final capTotal = await dataProvider.getVenueCapTotal(1);*/
    final workAreaTypes = await dataProvider.getWorkAreaTypes();

    setState(() {
/*      _lugaresDisponibles = disponibles;
      _capacidadTotal = capTotal;*/
      _workAreaTypes = workAreaTypes;
    });
      print('User id : ${prefs.userId}');
      _myReservations = await dataProvider.getMyReservations(prefs.userId);
      setState(() {});

    if(prefs.firstTutMenuReservas) {
      initTargets();
      showTutorial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Stack(
        children: [
          BackgroundPolygons(
              Colors.blue[700],
              Colors.blueAccent[100],
              HexColor('#0B1467'),
              HexColor('#182FF7')
          ),
            Column(
              children: [
                PhotoAppBarWidget(
                    label_reservas,
                    label_reservas_subtitle,
                    path_asset_image,
                    Color.fromRGBO(4, 73, 222, 0.7)
                ),
                SizedBox(height: 20),
                _escanearQR(context),
                SizedBox(height: 10.0),
                _listaWorkAreaTypes(),
                _labelMisReservas(),
                _mostrarReservasUsuario()
              ],
            ),
        ],
      )
    );
  }

  Container _labelMisReservas() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(mis_reservas,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800)),
        ));
  }

  Widget _escanearQR(BuildContext context){
    return Container(
      key: keyButton0,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Card(
        elevation: 5.0,
        color: HexColor('#FFB300'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: (){
            scanQR(context);
          },
          splashColor: Colors.blue,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
                Expanded(child: Text(escanear_qr, style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanQR(BuildContext context2) async {
    var barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", cancelar, true, ScanMode.QR);
      //print('VALOR SSCAN : $barcodeScanRes');
    } on PlatformException {
      barcodeScanRes = 'Falla al obtener la version de plataforma';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    //El usuario cancelo el escaneo
    if(barcodeScanRes == '-1')
      return;


    setState(() {
      var workAreaVar;
      Seat seat;
      MeetingRoom meetingRoom;
      String type = 'none';
      _scanBarcode = barcodeScanRes;

      Map<String, dynamic> decodedData;
      try{
        decodedData = json.decode(_scanBarcode);
      }on FormatException catch (e) {
        mostrarAlerta(context, error_al_obtener_informacion,
            la_informacion_contenida_en_este_qr);
        return;
      }

      WorkAreaType workAreaType = new WorkAreaType();

      if(decodedData.containsKey('idSeat')){

        workAreaVar = Seat.fromJson(decodedData);
        seat = workAreaVar;
        type = asiento;

        workAreaType.idCatWorkAreaType = WorkAreaType.ID_ASIENTO;
        workAreaType.imageUrl = img_url_escritorio;
        workAreaType.label = asiento;
        workAreaType.name = asiento;
      }

      if(decodedData.containsKey('idMeetingRoom')){
        workAreaVar = MeetingRoom.fromJson(decodedData);
        meetingRoom = workAreaVar;
        type = sala_de_juntas;

        workAreaType.idCatWorkAreaType = WorkAreaType.ID_SALA;
        workAreaType.imageUrl = img_url_sala_de_juntas;
        workAreaType.label = sala_de_juntas;
        workAreaType.name = sala_de_juntas;
      }

      if (type == sala_de_juntas) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(que_deseas_hacer),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BusquedaWorkAreaPage(
                                      workAreaType, null, workAreaVar, 'QR'))).then((value) async {
                            _myReservations = await dataProvider.getMyReservations(prefs.userId);
                            setState(() {});
                          });
                        },
                        child: Text(reservar)),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _validarReservaDeSala(meetingRoom,context2);
                        },
                        child: Text(chekin)),
                  ],
                ));
      } else if (type == asiento) {
        //print('menu reservas: id asiento : ${seat.idVenue}');
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(que_deseas_hacer),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BusquedaWorkAreaPage(
                                      workAreaType, seat, null, 'QR'))).then((value) async {
                            _myReservations = await dataProvider.getMyReservations(prefs.userId);
                            setState(() {});
                          });
                        },
                        child: Text(reservar)),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _validarChekinByQR(context, seat.idSeat);
                        },
                        child: Text(chekin)),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _validarChekoutByQR(context, seat.idSeat);
                        },
                        child: Text(label_checkout)),
                  ],
                ));
      } else {
        mostrarAlerta(context, error_al_obtener_informacion,
            la_informacion_contenida_en_este_qr);
      }
    }
    );
  }

  _validarChekinByQR(BuildContext context, int idAsientoSala){
    if(_myReservations.isEmpty){
      mostrarAlerta(context, sin_reservas_activas, no_se_puede_generar_chekin);
    }else{
      List<MyReservation> reservationsNoIniciadas = _getReservasWithChekinNull(_myReservations);
      if(reservationsNoIniciadas.isEmpty){
        mostrarAlerta(context, sin_reservas_activas, no_se_puede_generar_chekin);
      }else{
        List<MyReservation> reservationsValidadas = _getReservasFromUser(reservationsNoIniciadas, idAsientoSala);
        if(reservationsValidadas.isEmpty){
          mostrarAlerta(context, sin_reservas_activas, no_se_puede_generar_chekin);
        }else{
          showDialogoMiReserva(reservationsValidadas[0], context);
        }
      }
    }
  }

  _validarChekoutByQR(BuildContext context, int idAsientoSala){
    if(_myReservations.isEmpty){
      mostrarAlerta(context, sin_reservas_activas, no_se_puede_generar_chekout);
    }else{
      List<MyReservation> reservationsEnProceso = _getReservasEnProceso(_myReservations);
      if(reservationsEnProceso.isEmpty){
        mostrarAlerta(context, sin_reservas_activas, no_se_puede_generar_chekout);
      }else{
        List<MyReservation> reservationsValidadas = _getReservasFromUser(reservationsEnProceso, idAsientoSala);
        if(reservationsValidadas.isEmpty){
          mostrarAlerta(context, sin_reservas_activas, no_se_puede_generar_chekout);
        }else{
          showDialogoMiReserva(reservationsValidadas[0], context);
        }
      }
    }
  }

  _getReservasEnProceso(List<MyReservation> reservations){
    reservations = reservations.where((element) => element.status() == MyReservation.EN_PROCESO).toList();
    return reservations;
  }

  _getReservasWithChekinNull(List<MyReservation> reservations){
    reservations = reservations.where((element) => element.status() == MyReservation.NO_INICIADA).toList();
    return reservations;
  }

  _getReservasFromUser(List<MyReservation> reservations, int idAsientoSala){
    reservations = reservations.where((element) => element.idAsientoSala == idAsientoSala).toList();
    return reservations;
  }

  _validarReservaDeSala(MeetingRoom meetingRoom, BuildContext context) async {
    int hourInit = DateTime.now().hour;
    String hourInitString, hourEndString;
    if (hourInit < 10)
      hourInitString = '0${hourInit.toString()}';
    else
      hourInitString = '${hourInit.toString()}';

    if ((hourInit + 1) < 10)
      hourEndString = '0${(hourInit + 1).toString()}';
    else
      hourEndString = '${(hourInit + 1).toString()}';

    String fecha = normalDateBegginByYear(DateTime.now());

    DateTime dateTimeInit = DateTime.parse('$fecha $hourInitString:00:00');
    DateTime dateTimeEnd = DateTime.parse('$fecha $hourEndString:00:00');

    List<Reserva> salasReservadas = await dataProvider.getWorkAreasBooked(
        dateTimeInit.toUtc(),
        dateTimeEnd.toUtc(),
        meetingRoom.idMeetingRoom,
        prefs.userId,
        meetingRoom.idVenue,
        -1,
        2);

    if (salasReservadas.length == 0) {
      mostrarAlerta(context, no_existen_datos,
          '$no_existen_reservas_de_sala ${scheduleHHmmByDateTime(dateTimeInit)} $a ${scheduleHHmmByDateTime(dateTimeEnd)}$verifica_la_hora_de_tu_junta');
    } else {
      if (salasReservadas[0].bookingListRespObj == null ||
          salasReservadas[0].bookingListRespObj.length == 0) {
        mostrarAlerta(context, no_existen_datos,
            '$no_existen_reservas_de_sala ${scheduleHHmmByDateTime(dateTimeInit)} $a ${scheduleHHmmByDateTime(dateTimeEnd)}$verifica_la_hora_de_tu_junta');
      } else {
        String result = await dataProvider.createMeetingRoomCheckin(salasReservadas[0].bookingListRespObj[0].idReserv, prefs.userId);
        if (result == 'OK') {
          _myReservations = await dataProvider.getMyReservations(prefs.userId);
          showMessageOK(
              context,
              label_todo_bien,
              la_solicitud_se_realizo_de_manera_correcta);
        } else {
          showMessageError(context, label_ocurrio_un_error, result);
        }
        setState(() {});
      }
    }
  }

  Widget _listaWorkAreaTypes() {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.18;

    return _workAreaTypes != null
        ? AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
          opacity: closeTopContainer ? 0 : 1,
          child: AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: size.width,
      alignment: Alignment.topCenter,
      height: closeTopContainer ? 0 : categoryHeight,
            child: Container(
              key: keyButton1,
                height: categoryHeight,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: _listaItemsWorkAreaTypes(_workAreaTypes, context),
                ),
              ),
          ),
        )
        : Center(child: CircularProgressIndicator());
  }

  List<Widget> _listaItemsWorkAreaTypes(List<WorkAreaType> workAreaTypes, BuildContext context){
    final List<Widget> workAreaOptions = [];

    workAreaTypes.forEach((element) {
      final widgetTemp = _optWorkAreaType(element, context);
        workAreaOptions..add(widgetTemp);
    });

    return workAreaOptions;
  }

  Widget _optWorkAreaType(WorkAreaType workAreaType, BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
    return InkWell(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BusquedaWorkAreaPage(workAreaType, null, null, 'menu')))
            .then((value) async {
          _myReservations = await dataProvider.getMyReservations(prefs.userId);
          setState(() {});
        });
      },
      child: FittedBox(
        fit: BoxFit.fill,
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            Container(
                width: 160.0,
                margin: EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(62, 66, 107, 0.7),
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.topRight,
                                  child: FadeInImage(
                                    image: NetworkImage(workAreaType.imageUrl),
                                    height: 70.0,
                                    width: 70.0,
                                    placeholder: AssetImage(img_asseth_image_loading),
                                  )),
                              Text(
                                'Reservar',
                                style: TextStyle(
                                    color: Colors.white,
                                  fontSize: 14
                                ),
                              ),
                              Text(
                                workAreaType.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                )
            )
          ],
        ),
      )
    );
  }

  Widget _mostrarReservasUsuario() {
    return _myReservations != null
        ? _myReservations.isNotEmpty
          ? _listaDeMisReservas(_myReservations)
          : Center(key: keyButton2,child: Text(no_hay_datos_a_mostrar, style: TextStyle(fontSize: 30, color: Colors.white),))
        : Center(child: CircularProgressIndicator());
  }

  Widget _listaDeMisReservas(List<MyReservation> myReservations){
    return Expanded(
      key: keyButton2,
      child: ListView.builder(
        controller: _scrollController,
          itemCount: myReservations.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {

            double scale = 1.0;

            if(_topContainer < 0.5 && index == 0){
              scale = 1 - (_topContainer * 2);
              if (scale < 0) {
                scale = 0;
              } else if (scale > 1) {
                scale = 1;
              }
            }

            if (_topContainer > 0.5 ) {
              scale = index + 1 - (_topContainer * 2);
              if (scale < 0) {
                scale = 0;
              } else if (scale > 1) {
                scale = 1;
              }
            }
            return Opacity(
              opacity: scale,
              child: Transform(
                  transform:  Matrix4.identity()..scale(scale,scale),
                  alignment: Alignment.bottomCenter,
                  child: Align(
                    alignment: Alignment.topCenter,
                      child: _itemMisReservas(myReservations[index])
                  )
              ),
            );
          },
      ),
    );
  }

  Widget _itemMisReservas(MyReservation myReservation) {
    return ItemReservasProgramadas(
        myReservation,
        (myReservation.status() == MyReservation.FINALIZADA)
            ? null
            : () async {
          var data = await showDialog(context: context,
              builder: (BuildContext context){
                return ReservaInfoDialog(myReservation);
              }
          );
          if(data == 'OK'){
            _myReservations = await dataProvider
                .getMyReservations(myReservation.idUser);
            setState(() {});
            showMessageOK(context, '¡Correcto!', 'La petición se realizó de manera correcta');
          }else{
            showMessageError(context, 'Error en la petición', data);
          }
          //showDialogoMiReserva(myReservation, context)
        }

    );
  }


  Future<dynamic> showDialogoMiReserva(MyReservation myReservation, BuildContext context){
    final size = MediaQuery.of(context).size;
    DateTime reserva = DateTime.fromMillisecondsSinceEpoch(myReservation.startDate);
    DateTime reservaFin = DateTime.fromMillisecondsSinceEpoch(myReservation.endDate);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
              title: Text('$reserva_de ${myReservation.description}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900)),
              content: Container(
                height: size.height * 0.3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      datos(dia, DateFormat.yMMMMd('es_MX').format(DateTime.fromMillisecondsSinceEpoch(myReservation.endDate))),
                      Divider(thickness: 2),
                      datos(hora, '${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(myReservation.startDate))} $a ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(myReservation.endDate))}'),
                      Divider(thickness: 2),
                      datos(myReservation.description, myReservation.nameAsientoSala),
                      Divider(thickness: 2),
                    ],
                  ),
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: () async{
                      setState(() {
                        _isLoadingData = true;
                      });
                        if (myReservation.status() ==
                            MyReservation.NO_INICIADA) {
                          if(reserva.isBefore(DateTime.now()) && reservaFin.isAfter(DateTime.now())) {
                            String result = await myReservation.checkIn();
                            if (result == 'OK') {
                              _myReservations = await dataProvider
                                  .getMyReservations(myReservation.idUser);
                              showMessageOK(
                                  context,
                                  label_todo_bien,
                                  la_solicitud_se_realizo_de_manera_correcta
                              );
                            } else {
                              showMessageError(
                                  context,
                                  label_ocurrio_un_error,
                                  chekin_erroneo
                              );
                            }
                          }
                          else{
                            showMessageError(
                                context,
                                label_ocurrio_un_error,
                                chekin_aun_no_disponible
                            );
                          }
                        } else {
                          String result = await myReservation.checkOut();
                          if (result == 'OK') {
                            _myReservations = await dataProvider
                                .getMyReservations(myReservation.idUser);
                            showMessageOK(
                                context,
                                label_todo_bien,
                                la_solicitud_se_realizo_de_manera_correcta);
                          } else {
                            showMessageError(
                                context,
                                label_ocurrio_un_error,
                                checkout_erroneo
                            );
                          }
                        }
                    _isLoadingData = false;
                    setState(() {});
                    Navigator.pop(context);
                    },
                    child: _isLoadingData
                        ? CircularProgressIndicator()
                        : Text(myReservation.status() == MyReservation.NO_INICIADA
                        ? chekin
                        : chekout,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900))
                ),
              ],
            );
          });
        });
  }

  Widget datos(String dato, String valor) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric( vertical: 15.0),
            child: Text(dato,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                )),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton0,
        color: Colors.black12,
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
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton1,
        color: Colors.purple,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label_titulo_kb1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      label_mensaje_kb1,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: keyButton2,
      color: Colors.green,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    label_titulo_kb2,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  label_mensaje_kb2,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
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
        prefs.firstTutMenuReservas = false;
      },
      onClickTarget: (target) {
        prefs.firstTutMenuReservas = false;
      },
      onSkip: () {
        prefs.firstTutMenuReservas = false;
      },
      onClickOverlay: (target) {
        prefs.firstTutMenuReservas = false;
      },
    )..show();
  }
}
