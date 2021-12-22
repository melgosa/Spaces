import 'package:sigv4/sigv4.dart';

class Constantes {
  //Opciones de widget background personalizado
  static const int COLOR_AZUL = 0;
  static const int COLOR_ROJO = 1;
  static const int COLOR_GRIS = 2;

  //Opciones de pantalla perfil
  static const int INFO_GENERAL = 0;
  static const int MI_PERFIL_CLINICO = 1;
  static const int CAMBIAR_CONTRASENA = 2;
  static const int MI_BRAZALETE = 3;
  static const int OPCIONES = 4;

  static const int SUCCESS = 1;
  static const int ERROR = 2;

  static const int FROM_MENU = 1;
  static const int FROM_ACT_DIAG = 2;

  //Responses Types for questions
  static final SELECT = 1;
  static final CHEKBOX = 2;
  static final INPUT = 3;

  static final SURVEY_ACTIVE = 1;

  //AWS Services
  static const _accesKeyID = 'AKIAQNANITWGVLLVI44Z';
  static const _secretKeyID = 'Rcwgwz+dghO7EmkE7i2u7xgQIk7mBudJtwh75778';
  static const _regionName = 'us-east-1';
  static const _servicename = 'sns';
  static const platformApplicationArn = 'arn:aws:sns:us-east-1:027945115021:app/GCM/B2W';
  static var client = Sigv4Client(
    keyId: _accesKeyID,
    accessKey: _secretKeyID,
    region: _regionName,
    serviceName: _servicename
  );
}
