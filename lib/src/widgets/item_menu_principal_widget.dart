import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/icono_by_string_util.dart';

class ItemMenuPrincipalWidget extends StatelessWidget {
  final String optionName;
  final String itemDescription;
  final String iconName;
  final String iconBackgroundColor;
  final String ruta;

  ItemMenuPrincipalWidget(
      this.iconName,
      this.optionName,
      this.ruta,
      this.itemDescription,
      this.iconBackgroundColor
      );

  static const plattform =
  const MethodChannel("com.example.monitoria/pulceras");

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>  this.ruta == 'pulseras'
          ? printMessage('b8')
          : Navigator.pushNamed(context, this.ruta),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur( sigmaX: 5, sigmaY: 5 ),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(62, 66, 107, 0.5),
                borderRadius: BorderRadius.circular(15.0)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _customIcon(),
                _infoItem(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerTextBig(this.optionName),
          SizedBox(height: 5),
          _headerTextSmall(this.itemDescription, context),
        ],
      ),
    );
  }

  Widget _customIcon() {
    return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: HexColor(this.iconBackgroundColor)
            ),
            child: iconMeasurement(this.iconName, 35),
          ),
        );
  }

  Widget _headerTextBig(String text) {
    return Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 19.0)
    );
  }

  Widget _headerTextSmall(String content, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
          content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white54,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 12.0)
      ),
    );
  }

  void printMessage(String type) async {
    String value;
    try {
      value = await plattform.invokeMethod("init", {
        "type": type,
        "userName": prefs.userName,
        "idSeguimiento": prefs.userId
      });
    } catch (e) {
      print(e);
    }
    print(value);
  }
}
