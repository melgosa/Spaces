import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_ia/src/pages/login_page.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';

// ignore: non_constant_identifier_names
Widget AppBarPrincipal(String title, bool qr, BuildContext context, Color color) {
  final prefs = new PreferenciasUsuario();


  return AppBar(
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Icon(Icons.logout),
          onTap: () {
            /*Navigator.of(context)
                .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);*/
            /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                LoginPage()), (Route<dynamic> route) => false);*/

            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: new Text("Salir"),
                  content: new Text("¿Desea salir de la aplicación?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Salir'),
                      onPressed: () {
                        prefs.userId = 0;
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            LoginPage()), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                ));
          },
        ),
      )
    ],
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: color),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      centerTitle: true,
      //actions: (qr) ? [_showIconQR()] : [],
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color.fromRGBO(81, 86, 95, 1),
              ),
            ),
          ],
        ),
      ));
}
