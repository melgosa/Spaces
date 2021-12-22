import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/widgets/background_polygons_widget.dart';

class MedidasPrevencionPage extends StatefulWidget {
  final String tipoArea;
  MedidasPrevencionPage(this.tipoArea);

  @override
  _MedidasPrevencionPageState createState() => _MedidasPrevencionPageState();
}

class _MedidasPrevencionPageState extends State<MedidasPrevencionPage> {
  @override
  Widget build(BuildContext context) {
    String titulo =widget.tipoArea;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPolygons(
              Colors.blue[700],
              Colors.blueAccent[100],
              HexColor('#0B1467'),
              HexColor('#182FF7')
          ),
          _formulario()
        ],
      ),
    );
  }

  Widget _formulario(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _titulo(),
            SizedBox(height: 20),
            leyenda(),
            SizedBox(height: 20),
            _medidas('assets/img/mask.png', 'Usa cubrebocas', 'en todo momento'),
            SizedBox(height: 20),
            _medidas('assets/img/wash_hands.png', 'Lavate las manos', 'con agua y jabon o gel antibacterial'),
            SizedBox(height: 20),
            _medidas('assets/img/keep_distance.png', 'Manten la distancia', 'de al menos 2 metros'),
            SizedBox(height: 20),
            _botonContinuar(context),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }


  Widget _titulo() {
    return SafeArea(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromRGBO(62, 66, 107, 0.6),
            ),
            child: Center(
              child: Text(
                  'Medidas de prevención',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget leyenda(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Text(
          'Respeta las medidas de prevención dentro de las oficinas para evitar contagios de COVID 19',
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
  }

  Widget _medidas(String image, String titulo, String subtitulo){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromRGBO(62, 66, 107, 0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 30.0),
                    child: new Image.asset(
                      image ,
                      width: 80.0,
                      height: 80.0,)
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(titulo, style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                        ),
                        Text(subtitulo, style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonContinuar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
        child: RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: Text('Entendido', style: TextStyle(fontSize: 19),),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0.0,
          color: Color.fromRGBO(50, 112, 239, 1),
          textColor: Colors.white,
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('menuReservas'));
            //Navigator.pushNamedAndRemoveUntil(context, "menuReservas", (r) => true);
/*            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuReservas()));*/
          },
        ),

    );
  }
}
