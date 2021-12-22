import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:monitor_ia/src/models/meeting_room_controller_model.dart';
import 'package:monitor_ia/src/models/seat_model.dart';
import 'package:monitor_ia/src/models/venue_model.dart';
import 'package:monitor_ia/src/models/work_area.dart';
import 'package:monitor_ia/src/models/work_area_booked_model.dart';
import 'package:monitor_ia/src/models/work_area_types_model.dart';
import 'package:monitor_ia/src/pages/reserva_work_area_page.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/header_common_widget.dart';
import 'package:monitor_ia/src/widgets/snack_message_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const String label_todo_bien = '¡Todo bien!';
const String label_ocurrio_un_error = 'Ocurrió un error';
const String label_saltar = 'Saltar';
const String label_titulo_kb0 = 'Fecha de reserva';
const String label_mensaje_kb0 = 'Esta fecha por defecto es la corriente, pero puedes tocar este elemento y seleccionar una fecha del calendario, desde la fecha actual hasta 1 mes en adelante.\n\nToca para continuar el recorrido';
const String label_titulo_kb1 = 'Campo para filtrar la búsqueda de espacio';
const String label_mensaje_kb1 = 'Este capo es para elegir una sede, y a medida que establezcas valores en estos campos, aparecerán más para que refines aún más la búsqueda (como Piso, Asiento, etc.). Es necesario, al menos, elegir una sede para que se muestren resultados\n\nToca para continuar el recorrido';
const String label_titulo_kb2 = 'Horario de reserva';
const String label_mensaje_kb2 = 'Es necesario elegir un horario en el cual quieres reservar el espacio seleccionado. Los horarios comprenden desde las 8hrs. hasta las 21hrs. Es necesario seleccionar un horario, o no se podrá realizar la búsqueda\n\nToca para continuar el recorrido';
const String label_titulo_kb3 = 'Botones de acción';
const String label_mensaje_kb3 = 'Botón Cancelar y Búscar. El botón Buscar esta deshabilitado al cargar la pantalla, y para desbloquearlo es necesario, al menos, definir un horario\n\nToca para finalizar el recorrido en esta pantalla';


class BusquedaWorkAreaPage extends StatefulWidget {
  final WorkAreaType workAreaType;
  final Seat seat;
  final MeetingRoom meetingRoom;
  final String from;

  BusquedaWorkAreaPage(this.workAreaType, this.seat, this.meetingRoom, this.from, {Key key}) : super(key: key);

  @override
  _BusquedaWorkAreaPageState createState() => _BusquedaWorkAreaPageState();
}

class _BusquedaWorkAreaPageState extends State<BusquedaWorkAreaPage> {
  static const label_filtra_busqueda = 'Filtra la búsqueda por favor';
  static const label_todas_sedes = 'Todas las sedes';
  static const label_todos_los_pisos = 'Todos los pisos';
  static const label_todos_los_asientos = 'Todos los asientos';
  static const label_inicio = 'Inicio';
  static const label_fin = 'Fin';
  static const label_de = 'De';
  static const label_a = 'a';
  static const label_todas_las_salas = 'Todas las salas';
  static const label_todos_los_comedores = 'Todos los comedores';
  static const label_todas_las_areas_de_fumar = 'Todas las áreas de fumar';
  static const label_cancelar = 'Cancelar';
  static const label_buscar = 'Buscar';
  static const label_no_existen_asientos = 'No existen asientos en el piso elegido';
  static const label_no_existen_salas = 'No existen Salas en el Edificio elegido';
  static const label_no_existen_pisos = 'No existen pisos en el Edificio elegido';
  static const label_refina_busqueda = 'Refina un poco tu búsqueda...';
  static const label_todo_ocupado = 'No hay lugares disponibles con los filtros seleccionados';
  static const label_capacidad_total = 'Capacidad total:';
  static const label_ocupados = 'Ocupados:';

  Venue _venue;
  WorkArea _workArea;
  MeetingRoom _meetingRoom;
  Seat _seat;
  Schedule _scheduleInitHour;
  Schedule _scheduleEndHour;
  TextEditingController _seleccionarFecha = TextEditingController();
  TextEditingController _sedeQR = TextEditingController();
  TextEditingController _salaQR = TextEditingController();
  TextEditingController _asientoQR = TextEditingController();
  DateTime _selectedDate;

  List<Venue> _venues;
  List<WorkArea> _workAreas = [];
  List<MeetingRoom> _meetingRooms = [];
  List<Seat> _seats = [];
  List<Schedule> _schedulesInitHour = [];
  List<Schedule> _schedulesEndHour = [];

  bool _isLoadingData = false;

  int idRoomSeat = -1;
  int idVenue = -1;
  int idWorkArea = -1;
  int tipo = 0;

  String _fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String _lugaresDisponibles;
  String _capacidadTotal;

  final dataProvider = new B2WProvider();

  final key = new GlobalKey<ScaffoldState>();

  final prefs = new PreferenciasUsuario();

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton0 = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getAlldata();
    });
  }

  _getAlldata() async {
    _schedulesInitHour = Schedule.schedules(8, 0);
    _schedulesEndHour = Schedule.schedules(9, 1);
    final venues = await dataProvider.getVenuesByCompanyid(prefs.empresaid);
    _venues = venues;
    if(widget.from == 'QR'){
      if(widget.seat != null){
        _capacidadTotal = await dataProvider.getVenueCapTotal(widget.seat.idVenue);
        _lugaresDisponibles = await dataProvider.getDisponiblesByVenue(widget.seat.idVenue);
      }else if(widget.meetingRoom != null){
        _capacidadTotal = await dataProvider.getVenueCapTotal(widget.meetingRoom.idVenue);
        _lugaresDisponibles = await dataProvider.getDisponiblesByVenue(widget.meetingRoom.idVenue);
      }
    }

    setState(() {});

    if(prefs.firstTutBusquedaArea) {
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
              _formulario(context),
            ],
          ),
          _showBotones(context)
        ],
      ),
    );
  }

  Widget _formulario(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderCommon(label_filtra_busqueda),
          SizedBox(height: 20.0,),
          _selectFecha(),
          SizedBox(height: 20.0,),
          drawSede(),
        widget.from == 'QR'
            ? widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_ASIENTO
              ? _formularioParaAsientoQR()
              : _formularioParaOtrasWorkAreasQR()
            : widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_ASIENTO
              ? _formularioParaAsiento()
              : _formularioParaOtrasWorkAreas(),
          _showHorarios(),
          SizedBox(height: 80)
        ],
      ),
    );
  }

  Widget drawSede(){
    return widget.from == 'QR'
        ? _sede()
        : _venues != null
          ? _venues.isNotEmpty
            ? _dropDownSede(_venues)
            : Center(child: CircularProgressIndicator())
          : Center(child: CircularProgressIndicator());

  }

  Widget _sede(){
    String nombreSala;
    if(widget.meetingRoom != null){
      nombreSala = widget.meetingRoom.nameVenue;
    }
    else if(widget.seat!= null){
      nombreSala = widget.seat.nombreVenue.toString();
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            decoration: InputDecoration(
              //icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
                labelText: nombreSala,
                //DateTime.now().toIso8601String(),
                fillColor: Colors.white,
                filled: true
            ),
            focusNode: AlwaysDisabledFocusNode(),
            controller: _sedeQR,
            onTap: () {
            },
            enabled: false,
          ),
        ),
        Visibility(
          visible: _capacidadTotal != null && _lugaresDisponibles != null,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Capacidad Total: $_capacidadTotal', style: TextStyle(color: Colors.black, fontSize: 16),),
                    //_selectedDate != null ?  Text('${_selectedDate.toString()}', style: TextStyle(color: Colors.red, fontSize: 16),) :  Text('Ocupados: 0', style: TextStyle(color: Colors.red, fontSize: 16),),
                    Text('$label_ocupados ${_seleccionarFecha.text.isEmpty ? _lugaresDisponibles : _seleccionarFecha.text == _fecha ? _lugaresDisponibles : 0}', style: TextStyle(color: Colors.red, fontSize: 16),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _selectFecha() {
    return Container(
      key: keyButton0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.date_range, color: Colors.blue),
            labelText: _selectedDate == null
                ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                : '',
            //DateTime.now().toIso8601String(),
            labelStyle: TextStyle(color: Colors.blue, fontSize: 19),
            fillColor: HexColor('#D4E1FD'),
            filled: true
        ),
        focusNode: AlwaysDisabledFocusNode(),
        controller: _seleccionarFecha,
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        locale : const Locale("es","ES"),
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 30)),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: HexColor('#D4E1FD'),
                onSurface: Colors.blue,
              ),
              dialogBackgroundColor: HexColor('#D4E1FD'),
            ),
            child: Align(
              alignment: Alignment.center,
                child: child
            ),
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      final f = new DateFormat('yyyy-MM-dd');
      _seleccionarFecha
        ..text = f.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _seleccionarFecha.text.length,
            affinity: TextAffinity.upstream));
      setState(() {

      });
    }
  }

  Widget _dropDownSede(List<Venue> venues){
    return Column(
      key: keyButton1,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: DropdownButtonFormField(
            dropdownColor: HexColor('#D4E1FD'),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 30),
            style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.blue, fontSize: 19),
                hintText: label_todas_sedes,
                fillColor: HexColor('#D4E1FD'),
            ),
            items: venues.map<DropdownMenuItem<Venue>>(
                    (Venue value) {
                  return DropdownMenuItem<Venue>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(value.name),
                      ],
                    ),
                  );
                }).toList(),
            value: _venue,
            onChanged: (Venue value) async {
              _venue = value;

              _workArea = null;
              _workAreas = [];

              _capacidadTotal = null;
              _lugaresDisponibles = null;

              setState(() {});

              _capacidadTotal = await dataProvider.getVenueCapTotal(_venue.idVenue);
              _lugaresDisponibles = await dataProvider.getDisponiblesByVenue(_venue.idVenue);

              setState(() {});

                if (widget.workAreaType.name == WorkAreaType.ASIENTO) {
                  //Para limpiar el combo asientos cuando cambie el valor seleccionado del combo Sede
                  _seat = null;
                  _seats = [];
                  _workAreas = await dataProvider.getWorkAreasByVenue(_venue.idVenue);
                  if (_workAreas.isEmpty) {
                    showMessageError(
                        context,
                        label_ocurrio_un_error,
                        label_no_existen_pisos
                    );
                  }
                  setState(() {});
                } else {
                  _meetingRoom = null;
                  _meetingRooms = [];
                  _meetingRooms = await meetingRoomsToShow(_venue.idVenue, widget.workAreaType.idCatWorkAreaType);
                  if (_meetingRooms.isEmpty) {
                    showMessageError(
                        context,
                        label_ocurrio_un_error,
                        label_no_existen_salas
                    );
                  }
                  setState(() {});
                }
              setState(() {});
            },
          ),
        ),
        Visibility(
          visible: _capacidadTotal != null && _lugaresDisponibles != null,
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: HexColor('#FEF7C8'),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    )
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$label_capacidad_total $_capacidadTotal',
                      style: TextStyle(
                          color: HexColor('#FF9A00'),
                          fontSize: 18)
                    ),
                    Text(
                      '$label_ocupados ${_seleccionarFecha.text.isEmpty ? _lugaresDisponibles : _seleccionarFecha.text == _fecha ? _lugaresDisponibles : 0}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 19
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<MeetingRoom>> meetingRoomsToShow(idVenue, int type) async{
    List<MeetingRoom> meetingRooms = await dataProvider.getMeetingRoomsByVenue(_venue.idVenue);

    meetingRooms = meetingRooms.where((element) => element.idCatWorkAreaType == widget.workAreaType.idCatWorkAreaType).toList();

    return meetingRooms;
  }

  Widget _formularioParaAsiento(){
    return Column(
      children: [
        SizedBox(height: 20.0),
        Visibility(visible: _workAreas.isNotEmpty,
            child: Column(
              children: [
                _dropDownWorkAreas(_workAreas),
                SizedBox(height: 20.0),
              ],
            )),
        Visibility(visible: _seats.isNotEmpty,
            child: Column(
              children: [
                _dropDownSeats(_seats),
                SizedBox(height: 20.0),
              ],
            )),
      ],
    );
  }

  Widget _formularioParaAsientoQR(){
    return Column(
      children: [
        SizedBox(height: 20.0),
        Visibility(visible: widget.seat != null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      //icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
                        labelText: widget.seat.nombreWorkArea,
                        //DateTime.now().toIso8601String(),
                        fillColor: Colors.white,
                        filled: true
                    ),
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _salaQR,
                    onTap: () {
                    },
                    enabled: false,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      //icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
                        labelText: widget.seat.name,
                        //DateTime.now().toIso8601String(),
                        fillColor: Colors.white,
                        filled: true
                    ),
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _asientoQR,
                    onTap: () {
                    },
                    enabled: false,
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            )),
      ],
    );
  }

  Widget _dropDownWorkAreas(List<WorkArea> workAreas){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonFormField(
        dropdownColor: HexColor('#D4E1FD'),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 30),
        style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
          filled: true,
          hintStyle: TextStyle(color: Colors.blue, fontSize: 19),
          hintText: label_todos_los_pisos,
          fillColor: HexColor('#D4E1FD'),
        ),
        items: workAreas.map<DropdownMenuItem<WorkArea>>(
                (WorkArea value) {
              return DropdownMenuItem<WorkArea>(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.stairs, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(value.name),
                  ],
                ),
              );
            }).toList(),
        value: _workArea,
        onChanged: (WorkArea value) async{
          _workArea = value;

          _seat = null;
          _seats = [];

          setState(() {});

          _seats = await dataProvider.getSeatsByWorkArea(_workArea.idWorkArea);
          if(_seats.isEmpty){
            showMessageError(context, label_ocurrio_un_error, label_no_existen_asientos);
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _dropDownSeats(List<Seat> seats){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonFormField(
        dropdownColor: HexColor('#D4E1FD'),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 30),
        style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
          filled: true,
          hintStyle: TextStyle(color: Colors.blue, fontSize: 19),
          hintText: label_todos_los_asientos,
          fillColor: HexColor('#D4E1FD'),
        ),
        items: seats.map<DropdownMenuItem<Seat>>(
                (Seat value) {
              return DropdownMenuItem<Seat>(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.event_seat, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(value.name),
                  ],
                ),
              );
            }).toList(),
        value: _seat,
        onChanged: (Seat value) {
          setState(() {
            _seat = value;
          });
        },
      ),
    );
  }

  Widget _formularioParaOtrasWorkAreas(){
    return Column(
      children: [
        SizedBox(height: 20.0),
        Visibility(visible: _meetingRooms.isNotEmpty,
            child: Column(
              children: [
                _dropDownMeetingRooms(_meetingRooms),
                SizedBox(height: 20.0),
              ],
            )),
      ],
    );
  }

  Widget _formularioParaOtrasWorkAreasQR(){
    return Column(
      children: [
        SizedBox(height: 20.0),
        Visibility(visible: widget.meetingRoom != null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      //icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
                        labelText: widget.meetingRoom.name,
                        //DateTime.now().toIso8601String(),
                        fillColor: Colors.white,
                        filled: true
                    ),
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _salaQR,
                    onTap: () {
                    },
                    enabled: false,
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            )),
      ],
    );
  }

  Widget _dropDownMeetingRooms(List<MeetingRoom> meetingRooms) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonFormField(
        dropdownColor: HexColor('#D4E1FD'),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 30),
        style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
          filled: true,
          hintStyle: TextStyle(color: Colors.blue, fontSize: 19),
          hintText: label_todas_las_salas,
          fillColor: HexColor('#D4E1FD'),
        ),
        items: meetingRooms.map<DropdownMenuItem<MeetingRoom>>(
                (MeetingRoom value) {
              return DropdownMenuItem<MeetingRoom>(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.meeting_room, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(value.name),
                  ],
                ),
              );
            }).toList(),
        value: _meetingRoom,
        onChanged: (MeetingRoom value) {
          setState(() {
            _meetingRoom = value;
          });
        },
      ),
    );
  }

  String tipoDeLetero(){
    String letrero = '';
    if(widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_SALA)
      letrero = label_todas_las_salas;
    if(widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_COMEDOR)
      letrero = label_todos_los_comedores;
    if(widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_AREA_DE_FUMAR)
      letrero = label_todas_las_areas_de_fumar;

    return letrero;
  }

  Widget _showHorarios() {
    return Container(
      key: keyButton2,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label_de, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          _dropDownStartHour(_schedulesInitHour),
          Text(label_a, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          _dropDownEndHour(_schedulesEndHour),
        ],
      ),
    );
  }

  Widget _dropDownStartHour(List<Schedule> schedules){
    return Container(
      width: 145,
      child: DropdownButtonFormField(
        dropdownColor: HexColor('#D4E1FD'),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 30),
        style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
          filled: true,
          hintStyle: TextStyle(color: Colors.blue, fontSize: 19),
          hintText: label_inicio,
          fillColor: HexColor('#D4E1FD'),
        ),
        items: schedules.map<DropdownMenuItem<Schedule>>(
                (Schedule value) {
              return DropdownMenuItem<Schedule>(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.watch_later, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(value.hourToShow),
                  ],
                ),
              );
            }).toList(),
        value: _scheduleInitHour,
        onChanged: (Schedule value) {
          setState(() {
            _scheduleInitHour = value;
            _scheduleEndHour = null;
            _schedulesEndHour = [];
            _schedulesEndHour = Schedule.schedules(_scheduleInitHour.id + 1, 1);
          });
        },
      ),
    );
  }

  Widget _dropDownEndHour(List<Schedule> schedules){
    return Container(
      width: 145,
      child: DropdownButtonFormField(
        dropdownColor: HexColor('#D4E1FD'),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 30),
        style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
          filled: true,
          hintStyle: TextStyle(color: Colors.blue, fontSize: 19),
          hintText: label_fin,
          fillColor: HexColor('#D4E1FD'),
        ),
        items: schedules.map<DropdownMenuItem<Schedule>>(
                (Schedule value) {
              return DropdownMenuItem<Schedule>(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.watch_later, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(value.hourToShow),
                  ],
                ),
              );
            }).toList(),
        value: _scheduleEndHour,
        onChanged: (Schedule value) {
          setState(() {
            _scheduleEndHour = value;
          });
        },
      ),
    );
  }

  Widget _showBotones(BuildContext context) {
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
            key: keyButton3,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _botonCancelar(),
              SizedBox(width: 10),
              _botonContinuar(context),
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
          child: Text(label_cancelar, style: TextStyle(fontSize: 20)),
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

  Widget _botonContinuar(BuildContext context) {
    return Expanded(
      child: RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: _isLoadingData
              ? Container(height: 20.0, width: 20.0,child: Center(child: CircularProgressIndicator()))
              : Text(label_buscar, style: TextStyle(fontSize: 20),),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.0,
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: _isLoadingData || _scheduleInitHour == null || _scheduleEndHour == null ? null : _searchBookes
      ),
    );
  }

  _searchBookes() async{
    tipo = widget.workAreaType.idCatWorkAreaType;
    _combosLogic();
    if(idVenue == -1){
      showMessageError(context, label_ocurrio_un_error, label_refina_busqueda);
    }else{
      _isLoadingData = true;

      String fechaSeleccionada = _seleccionarFecha.text.isEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
          : _seleccionarFecha.text;

      var dateInit = DateTime.parse('$fechaSeleccionada ${_scheduleInitHour.hourToSend}');
      //print('Date init : $fechaSeleccionada ${_scheduleInitHour.hourToSend}');
      var dateEnd = DateTime.parse('$fechaSeleccionada ${_scheduleEndHour.hourToSend}');
      setState(() {});
      List<WorkAreaBooked> workAreasBooked =
          await dataProvider.getWorkAreasBooked2(
              dateInit.toUtc(),
              dateEnd.toUtc(),
              idRoomSeat,
              prefs.userId,
              idVenue,
              idWorkArea,
              tipo);

      workAreasBooked = _getWorkAreasAvailables(workAreasBooked);

      if(workAreasBooked.isNotEmpty){
        var venueToSend;
        if(widget.from == 'QR'){
          Venue venue = new Venue();
          if(widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_ASIENTO) {
            venue.idVenue = widget.seat.idVenue;
            venue.name = widget.seat.nombreVenue;
            venue.address = '';
          }else{
            venue.idVenue = widget.meetingRoom.idVenue;
            venue.name = widget.meetingRoom.nameVenue;
            venue.address = '';
          }
          venueToSend = venue;
        }else{
          venueToSend = _venue;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReservaWorkAreaPage(
                    workAreasBooked, widget.workAreaType, venueToSend, dateInit, dateEnd)));

      }else{
        showMessageError(context, label_ocurrio_un_error, label_todo_ocupado);
      }
    }
    _isLoadingData = false;
    setState(() {});
  }

  _combosLogic(){
    if(widget.from == 'QR'){
      if(widget.workAreaType.idCatWorkAreaType == WorkAreaType.ID_ASIENTO){
        idVenue = widget.seat.idVenue;
        idWorkArea = widget.seat.idWorkArea;
        idRoomSeat = widget.seat.idSeat;
      }else{
        idVenue = widget.meetingRoom.idVenue;
        idWorkArea = -1;
        idRoomSeat = widget.meetingRoom.idMeetingRoom;
      }
    }else{
      idRoomSeat = -1;
      idVenue = -1;
      idWorkArea = -1;
    }
    if(tipo == WorkAreaType.ID_ASIENTO){
      //Se selecciono asiento por el usuario desde el combo
      if(_seat != null){
        idRoomSeat = _seat.idSeat;
        idWorkArea = _seat.idWorkArea;
        idVenue = _venue.idVenue;
        //Se dejo libre combo asiento
      }else{
        //Se selecciono piso por el usuario desde el combo
        if(_workArea != null){
          idWorkArea = _workArea.idWorkArea;
          idVenue = _workArea.idVenue;
          //Se dejo libre combo piso
        }else{
          //Se selecciono sede por el usuario desde el combo
          if(_venue != null){
            idVenue = _venue.idVenue;
          }
        }
      }
    }else{
      if(_meetingRoom != null){
        idRoomSeat = _meetingRoom.idMeetingRoom;
        idVenue = _meetingRoom.idVenue;
      }else{
        //Se selecciono sede por el usuario desde el combo
        if(_venue != null){
          idVenue = _venue.idVenue;
        }
      }
    }
    //print('idRoomSeat : $idRoomSeat, idVenue: $idVenue, idWorkArea: $idWorkArea, tipo: $tipo');
  }

  List<WorkAreaBooked> _getWorkAreasAvailables(List<WorkAreaBooked> workAreasBookedInit){
    //Para obtener los ids de los objetos que no cumplen con lo requerido (estan ocupados
    //en el intervalo de tiempo solicitado por el usuario
    List<int> idsToRemove = [];
    workAreasBookedInit.forEach((element) {
      if(!element.bookings.first.available){
        idsToRemove.add(element.idRoomSeat);
      }
    });

    //Elimina de la lista los objetos con los ids guardados anteriormente
    if(idsToRemove.length > 0){
      idsToRemove = idsToRemove.toSet().toList();
      for(int i = 0; i < idsToRemove.length; i++){
        workAreasBookedInit.removeWhere((element) => element.idRoomSeat == idsToRemove[i]);
      }
    }

    //El penultimo listado, contiene los objetos que cumplen, pero hay repeticiones
    //por como fue elaborado el WS, asi que para mostrarlos, hay que eliminar los repetidos
    final ids = workAreasBookedInit.map((e) => e.idRoomSeat).toSet();
    workAreasBookedInit.retainWhere((x) => ids.remove(x.idRoomSeat));

    return workAreasBookedInit;
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
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyButton3,
      color: Colors.deepOrangeAccent,
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
                    label_titulo_kb3,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  label_mensaje_kb3,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
      shape: ShapeLightFocus.RRect,
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
        prefs.firstTutBusquedaArea = false;
      },
      onClickTarget: (target) {
        prefs.firstTutBusquedaArea = false;
      },
      onSkip: () {
        prefs.firstTutBusquedaArea = false;
      },
      onClickOverlay: (target) {
        prefs.firstTutBusquedaArea = false;
      },
    )..show();
  }

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

