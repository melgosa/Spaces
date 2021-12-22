import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/providers/tutorial_management_provider.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/item_menu_principal_widget.dart';
import 'package:monitor_ia/src/providers/static_data_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/principal_app_bar_widget.dart';


const String saltar = "SALTAR";
const String condicion_basal = "Condición basal";
const String puedes_conocer_tu_condicion = "Puedes conocer tu condición de salud";
const String en_este_menu_puedes_elegir = "En este menú puedes elegir entre las diferentes opciones ya sea para mostrar tu código QR con tu estado de salud, revisar tu perfil clínico, reservar una sala o escritorio, o realizar las encuestas que hay para ti";
const String opciones = "Opciones";
const String este_es_tu_id_de_seguimiento = "Este es tu Id de seguimiento con el cual te puedes identificar";
const String id_de_seguimiento = "ID de seguimiento";
const String que_deseas_hacer = '¿Qué deseas hacer?';
const String tu_condicion_de_salud_es = 'Tu condición de salud es:';
const String id_de_seguimiento_points = 'ID de seguimiento:';
const String hola_saludo = '¡Hola';
const String si = 'Sí';
const String no = 'No';
const String salir = '¿Salir?';
const String deseas_salir_de_la_app = '¿Deseas salir de la aplicación?';
const String back_to_work = 'Back To Work';
const String path_asseth_img = 'assets/img/inicio_back.png';
const String label_titulo_kb0 = 'Listado de funciones';
const String label_mensaje_kb0 = 'Aquí se muestran las funciones principales que puedes utilizar en la app, con una breve descripción acerca de ellas, tales como Reserva de espacios, Encuestas y Mi Pulsera\n\nToca para finalizar el recorrido en esta pantalla';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final prefs = new PreferenciasUsuario();

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButton0 = GlobalKey();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final tutorialProvider = Provider.of<TutorialManagementProvider>(context);
    if(tutorialProvider.canInitSecondTutorial){
      if(prefs.firstTutInicio) {
        initTargets();
        showTutorial();
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
              HexColor('#ABFCF3'),
              HexColor('#ABFCF3'),
              HexColor('#02E8CC'),
              HexColor('#02E8CC')),
          _cargarVistaInicio()
        ],
      ),
    );
  }

  Widget _cargarVistaInicio() {
    return Column(
      children: [
        PrincipalAppBar('¡Hola ${prefs.userName}!', 'ID de Seguimiento: ${prefs.userId}'),
        _showLabelQueDeseas(),
        _listaOpciones(),
      ],
    );
  }

  Widget _showLabelQueDeseas() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(que_deseas_hacer,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
      ),
    );
  }

  Widget _listaOpciones() {
    return FutureBuilder(
        future: staticDataProvider.cargarDataMenuInicio(),
        initialData: [],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Expanded(
            child: ListView(
              key: keyButton0,
              children: _listaItems(snapshot.data, context),
            ),
          );
        });
  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    data.forEach((element) {
      final widgetTemp =
      ItemMenuPrincipalWidget(
          element['icon'],
          element['texto'],
          element['ruta'],
          element['descripcion'],
          element['iconColor'],
      );
      opciones..add(widgetTemp)..add(SizedBox(height: 15));
    });
    return opciones;
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton0,
        color: Colors.pinkAccent,
        contents: [
          TargetContent(
            align: ContentAlign.top,
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
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: saltar,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        prefs.firstTutInicio = false;
      },
      onClickTarget: (target) {
        prefs.firstTutInicio = false;
      },
      onSkip: () {
        prefs.firstTutInicio = false;
      },
      onClickOverlay: (target) {
        prefs.firstTutInicio = false;
      },
    )..show();
  }
}
