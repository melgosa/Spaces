import 'package:flutter/material.dart';

import 'package:monitor_ia/src/models/survey_by_empresa_response.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';

import 'b2w_provider.dart';

class SeleccionEncuestaProvider with ChangeNotifier{
  List<SurveyByEmpresaResponse> _surveysByEmpresa;
  final b2wProvider = B2WProvider();
  final prefs = PreferenciasUsuario();

  List<SurveyByEmpresaResponse> get surveysByEmpresa => this._surveysByEmpresa;

  SeleccionEncuestaProvider(){
    _getSurveys();
  }

  _getSurveys() async {
    _surveysByEmpresa = await b2wProvider.getListOfSurveysByEmpresa(prefs.empresaid);
    notifyListeners();
  }

}