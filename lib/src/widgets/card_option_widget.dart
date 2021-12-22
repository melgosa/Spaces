import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/utils/icono_by_string_util.dart';
import 'package:hexcolor/hexcolor.dart';

const String googleFitPackageName = "com.google.android.apps.fitness";
const String alert_title = "App Google Fit";
const String alert_message =
    "La aplicación Google Fit es necesaria para poder utilizar esta funcionalidad.¿Deseas descargarla de la Play Store?";
const String cancelar = "Cancelar";
const String descargar = "Descargar";

class CardOption extends StatelessWidget {
  static const plattform =
      const MethodChannel("com.example.monitoria/pulceras");

  final String textOption;
  final String nameIconLeft;
  final String rutaSelected;
  final String backgoundColor;
  final String iconColor;
  final String textColor;
  final prefs = new PreferenciasUsuario();

  CardOption(this.nameIconLeft, this.textOption, this.rutaSelected,
      this.backgoundColor, this.iconColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Card(
        elevation: 5.0,
        color: HexColor(backgoundColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.white, width: 2)),
        child: InkWell(
          onTap: () async {
            if (rutaSelected == 'pulseras') {
              printMessage('b8');
            } else {
              Navigator.pushNamed(context, rutaSelected);
            }
          },
          splashColor: Colors.blue,
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getIconMeasurement(nameIconLeft, 24.0, iconColor),
                Expanded(
                  child: Text(
                    textOption,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: HexColor(textColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
