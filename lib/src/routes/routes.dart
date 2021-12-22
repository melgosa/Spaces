import 'package:flutter/material.dart';

import 'package:monitor_ia/src/pages/busqueda_work_area_page.dart';
import 'package:monitor_ia/src/pages/seleccion_encuesta_page.dart';
import 'package:monitor_ia/src/pages/login_page.dart';
import 'package:monitor_ia/src/pages/menu_reservas_page.dart';
import 'package:monitor_ia/src/pages/opciones_from_perfil_page.dart';
import 'package:monitor_ia/src/pages/principal_page.dart';
import 'package:monitor_ia/src/pages/splash_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => SplashPage(),
    'splash': (BuildContext context) => SplashPage(),
    'login': (BuildContext context) => LoginPage(),
    'opciones': (BuildContext context) => OpcionesFromPerfil(),
    // rutas de menu principal
    'encuestas': (BuildContext context) => SeleccionEncuestaPage(),
    'menuReservas' : (BuildContext context) => MenuReservas(),
    'busquedaWorkArea' : (BuildContext context) => BusquedaWorkAreaPage(null, null, null, ''),
    'principal' : (BuildContext context) => PrincipalPage(),
  };
}
