import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:monitor_ia/src/providers/seleccion_encuesta_page_provider.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';
import 'package:monitor_ia/src/widgets/card_icon_item_widget.dart';
import 'package:monitor_ia/src/widgets/photo_app_bar_widget.dart';

const String img_asset_path = 'assets/img/survey_fondo.jpg';
const String saltar = "SALTAR";
const String label_page_title = 'Encuestas';
const String label_page_subtitle = 'Ayuda a mejorar la calidad de los servicios';
const String hola_saludo = '¡Hola';
const String id_de_seguimiento = 'ID de seguimiento:';
const String label_selecciona_la_encuesta = 'Toca la encuesta que deseas contestar';
const String label_puedes_realizar_las_diferentes_encuestas = "Puedes realizar las diferentes encuestas que se encuentran disponibles para ti";
const String label_no_hay_encuestas_disponibles = "No hay encuestas disponibles";


class SeleccionEncuestaPage extends StatefulWidget {
  @override
  _SeleccionEncuestaPageState createState() => _SeleccionEncuestaPageState();
}

class _SeleccionEncuestaPageState extends State<SeleccionEncuestaPage> {
  GlobalKey keyButton = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final seleccionEncuestaProvider = Provider.of<SeleccionEncuestaProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
            HexColor('#0B1467'),
            HexColor('#182FF7'),
            HexColor('#DA05DC'),
            HexColor('#DFA6E0'),
          ),
          Column(
            children: [
              PhotoAppBarWidget(
                  label_page_title,
                  label_page_subtitle,
                  img_asset_path,
                  Color.fromRGBO(250, 53, 240, 0.75)
              ),
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        label_selecciona_la_encuesta,
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800)
                    ),
                  )),
              _listaDeEncuestasDisponibles(seleccionEncuestaProvider),
            ],
          )
        ],
      )
    );
  }

  Widget _listaDeEncuestasDisponibles(SeleccionEncuestaProvider seleccionEncuestaProvider){
    if(seleccionEncuestaProvider.surveysByEmpresa == null){
      return Center(child: CircularProgressIndicator());
    }else if(seleccionEncuestaProvider.surveysByEmpresa.isEmpty){
      return Container(
        margin: EdgeInsets.all(30),
        child: Center(
            child: Text(
              label_no_hay_encuestas_disponibles,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
        )),
      );
    }else{
      return Expanded(
        child: GridView.count(
            crossAxisCount: 2,
          children: List.generate(seleccionEncuestaProvider.surveysByEmpresa.length, (index) {
            return CardIconItem(
                seleccionEncuestaProvider.surveysByEmpresa[index].survey,
                seleccionEncuestaProvider.surveysByEmpresa[index].idSurvey
            );
          }),
        ),
      );
    }
  }
}
