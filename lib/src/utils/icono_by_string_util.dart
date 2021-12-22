import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final _icons = <String, IconData>{
  'add_alert': Icons.add_alert,
  'accessibility': Icons.accessibility,
  'folder_open': Icons.folder_open,
  'donut_large': Icons.donut_large,
  'input': Icons.input,
  'tune': Icons.tune,
  'list': Icons.list,
  //Iconos de opciones de Perfil
  'how_to_reg': Icons.how_to_reg,
  'medical_servicesility': Icons.medical_services,
  'update': Icons.update,
  'watch': Icons.watch,
  'settings': Icons.settings,
  'qr_code': Icons.qr_code,
  'meeting_room': Icons.meeting_room,
  'health': Icons.sports,
  'fitness_center': Icons.fitness_center,
  'bloodtype': Icons.bloodtype,
  'favorite': Icons.favorite,
  'local_pharmacy': Icons.local_pharmacy,
  'thermostat': Icons.thermostat,
  'note': Icons.note,
  'book_online_outlined': Icons.book_online_outlined,
  'fact_check_outlined ': Icons.fact_check_outlined ,

  //Iconos de opciones inicio
  'content_paste' : Icons.content_paste,
  'emoji_transportation' : Icons.emoji_transportation
};

Icon getIcon(String nombreIcono) {
  return Icon(_icons[nombreIcono], color: Colors.white);
}

Icon iconMeasurement(String nombreIcono, double tamano) {
  return Icon(_icons[nombreIcono], color: Colors.white, size: tamano);
}

Icon getIconMeasurement(String nombreIcono, double tamano, String color) {
  return Icon(_icons[nombreIcono], color: HexColor(color), size: tamano);
}
