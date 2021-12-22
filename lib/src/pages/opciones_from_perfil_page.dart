import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_ia/src/providers/static_data_provider.dart';
import 'package:monitor_ia/src/widgets/app_bar_principal.dart';
import 'package:monitor_ia/src/widgets/card_option_widget.dart';

class OpcionesFromPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPrincipal('Perfil', true, context, Color.fromRGBO(48, 63, 159, 1.0)),
      body: Stack(
        children: [
          _cargarFondo(),
          _showMenuPerfil(context),
        ],
      ),
    );
  }

  Widget _cargarFondo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.0, 1.0),
              colors: [
                Color.fromRGBO(25, 118, 210, 1.0),
                Color.fromRGBO(48, 63, 159, 1.0),
              ])),
    );
  }

  Widget _showMenuPerfil(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              _showInfoGeneral(),
            ],
          ),
          _listaOpciones()
        ],
      ),
    );
  }

  Widget _showInfoGeneral() {
    return ClipRect(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _showMenu(),
          ],
        ),
      ),
    );
  }

  Widget _showMenu() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Container(
        child: Text('Opciones',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: Colors.white,
          ),),
      ),
    );
  }

  Widget _lineDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: Divider(
          color: Colors.white70
      ),
    );
  }


  Widget _listaOpciones() {
    return FutureBuilder(
        future: staticDataProvider.cargarDataMenuOpciones(),
        initialData: [],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: ListView(
                  children: _listaItems(snapshot.data, context),
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    opciones..add(bigTitle('Servicios'))..add(_lineDivider())..add(SizedBox(height: 20));

    int i = 0;
    data.forEach((element) {
      i++;
      if (i == 2) {
        opciones..add(bigTitle('Permisos'))..add(_lineDivider())..add(SizedBox(height: 20));
      }
      final widgetTemp =
          CardOption(element['icon'], element['texto'], element['ruta'],element['backgoundColor'],element['iconColor'],element['textColor']);
      opciones..add(widgetTemp)..add(SizedBox(height: 20));
    });

    return opciones;
  }

  Widget bigTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
