import 'package:monitor_ia/src/utils/constants_utils.dart';
import 'package:flutter/material.dart';

Widget CustomBackground(int color, String pathAssetBackground){
  Color backGroundColor;

  switch(color){
    case Constantes.COLOR_ROJO:
      backGroundColor = Color.fromRGBO(189, 48, 48 , 0.9);
      break;
    case Constantes.COLOR_GRIS:
      backGroundColor = Color.fromRGBO(84, 110, 122 , 0.9);
      break;
    case Constantes.COLOR_AZUL:
      backGroundColor = Color.fromRGBO(20, 60, 122 , 0.9);
      break;
    default:
      backGroundColor = Color.fromRGBO(20, 60, 122 , 0.9);
      break;
  }

  return Container(
    height: double.infinity,
    width: double.infinity,
    child: ColorFiltered(
      colorFilter: ColorFilter.mode(backGroundColor, BlendMode.srcOver),
      child: Image(
        fit: BoxFit.fill,
        image: AssetImage(pathAssetBackground),
      ),
    ),
  );
}