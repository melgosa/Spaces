import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class _StaticDataProvider {
  List<dynamic> opciones = [];
  _StaticDataProvider() {
    //cargarData();
  }

  Future<List<dynamic>> cargarDataMenuMiPerfil() async {
    final resp = await rootBundle.loadString('data/mi_perfil_opciones.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<List<dynamic>> cargarDataMenuOpciones() async {
    final resp = await rootBundle.loadString('data/opt_opciones.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<List<dynamic>> cargarDataMenuInicio() async {
    final resp = await rootBundle.loadString('data/opt_inicio1.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<List<dynamic>> cargarDataMenuRetornoNormalidad() async {
    final resp = await rootBundle.loadString('data/opt_retorno_normalidad.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<List<dynamic>> cargarDataMenuEncuestas() async {
    final resp = await rootBundle.loadString('data/opt_encuestas.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<List<dynamic>> cargarDataMenuSalud() async {
    final resp = await rootBundle.loadString('data/salud_options.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['rutas'];

    return opciones;
  }

  Future<String> cargarPickerDataTemperatura() async {
    final resp = await rootBundle.loadString('data/picker_options.json');

    return resp;
  }

  Future<List<dynamic>> loadBackgroundColors() async {
    final resp = await rootBundle.loadString('data/background_color_list.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['colors'];

    return opciones;
  }
}

final staticDataProvider = new _StaticDataProvider();
