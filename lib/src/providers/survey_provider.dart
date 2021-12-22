import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:monitor_ia/src/models/survey_response.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';

const String label_content_error_survey_rleppc = 'Responde la encuesta para poder continuar';
const String label_content_error_survey_nshrleestvpf = 'No se ha respondido la encuesta en su totalidad, verifica por favor';

class SurveyProvider extends ChangeNotifier {
  final _b2wProvider = B2WProvider();
  SurveyResponse _surveyResponse;
  List<Map<String, dynamic>> _values = [];
  String _jsonResult = '';
  List<int> _allQuestionsAnswered = [];
  String _descriptionErrorInSurvey = '';
  String _idSurveyAnswered = '';
  bool _isConnectingToServer = false;

  SurveyResponse get surveyResponse => this._surveyResponse;
  String get descriptionErrorInSurvey => this._descriptionErrorInSurvey;
  bool get isConnectingToServer => this._isConnectingToServer;

  set isConnectingToServer( bool value ) {
    this._isConnectingToServer = value;
    notifyListeners();
  }

  getSurvey(int idSurvey) async {
    final b2wProvider = B2WProvider();
    this._surveyResponse = await b2wProvider.getSurvey(idSurvey);
    this._isConnectingToServer = false;
    notifyListeners();
  }

  Future<String> registerSurveyAnswered(int idSurvey, int idUser) async {
    this._idSurveyAnswered = await _b2wProvider.registerSurveyAnswered(idSurvey, idUser);
    return this._idSurveyAnswered;
  }

  Future<String> registerQuestionsAnswered() async {
    String idUserSurvey = this._idSurveyAnswered;
    var res = this._jsonResult.replaceAll('"xXxXx":-1', '"idUserSurvey":$idUserSurvey');
    print(res);
    String response = await _b2wProvider.registerQuestionsAnswered(res);
    return response;
  }

  onUpdateRaddio(int idQuestion, int idAnswer, String val) {
    int foundKey = -1;

    for (var map in _values) {
      if (map.containsKey('idCatQuestion')) {
        if (map['idCatQuestion'] == idQuestion) {
          foundKey = idQuestion;
          break;
        }
      }
    }

    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['idCatQuestion'] == foundKey;
      });
    }

    Map<String, dynamic> jsonCreated = {
      'idCatQuestion': idQuestion,
      'idCatResponse': idAnswer,
      'responseText': '',
      'xXxXx': -1
    };

    _values.add(jsonCreated);
    _jsonResult = json.encode(_values);
    print(_jsonResult);
    _allQuestionsAnswered.add(idQuestion);
    _allQuestionsAnswered = _allQuestionsAnswered.toSet().toList();
    print('TotalQuestions: ${_surveyResponse.questions.length}');
    print('TotalQuestionsAnswered: ${_allQuestionsAnswered.length}');
    notifyListeners();
  }

  onUpdateCheckBox(int idQuestion, int idAnswer, bool isCkecked) {
    int foundKey = -1;
    bool isIdQuestionInArray = false;

    for (var map in _values) {
      if (map.containsKey('idCatResponse')) {
        if (map['idCatResponse'] == idAnswer) {
          foundKey = idAnswer;
          break;
        }
      }
    }

    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['idCatResponse'] == foundKey;
      });
    }

    Map<String, dynamic> jsonCreated = {
      'idCatQuestion': idQuestion,
      'idCatResponse': idAnswer,
      'responseText': '',
      'xXxXx': -1
    };

    if(isCkecked) {
      _values.add(jsonCreated);
      _allQuestionsAnswered.add(idQuestion);
    }

    _jsonResult = json.encode(_values);
    print(_jsonResult);


    for(var map in _values){
      if(map.containsKey('idCatQuestion')){
        if(map['idCatQuestion'] == idQuestion){
          isIdQuestionInArray = true;
          break;
        }
      }
    }

    //Elimina las repetciones en la lista de ID's
    _allQuestionsAnswered = _allQuestionsAnswered.toSet().toList();
    //Si despues de hacer el filtro de ID's de respuestas, el id actual no se encuentra
    //en la nueva lista forltrada, entonces remover el id de la pregunta, porque
    //ya no existe en el arreglo JSON de respuestas
    if(!isIdQuestionInArray)
      _allQuestionsAnswered.remove(idQuestion);

    print('TotalQuestions: ${_surveyResponse.questions.length}');
    print('TotalQuestionsAnswered: ${_allQuestionsAnswered.length}');
    notifyListeners();
  }

  onUpdateInput(int idQuestion, int idAnswer, String answer) {
    int foundKey = -1;

    for (var map in _values) {
      if (map.containsKey('idCatQuestion')) {
        if (map['idCatQuestion'] == idQuestion) {
          foundKey = idQuestion;
          break;
        }
      }
    }

    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['idCatQuestion'] == foundKey;
      });
    }

    Map<String, dynamic> jsonCreated = {
      'idCatQuestion': idQuestion,
      'idCatResponse': idAnswer,
      'responseText': answer,
      'xXxXx': -1
    };


    if(answer.length > 0){
      _values.add(jsonCreated);
      _allQuestionsAnswered.add(idQuestion);
    }

    _jsonResult = json.encode(_values);
    print(_jsonResult);


    _allQuestionsAnswered = _allQuestionsAnswered.toSet().toList();

    if(answer.length == 0)
      _allQuestionsAnswered.remove(idQuestion);

    print('TotalQuestions: ${_surveyResponse.questions.length}');
    print('TotalQuestionsAnswered: ${_allQuestionsAnswered.length}');
    notifyListeners();
  }


  clearAllValues(){
    this._values.clear();
    this._allQuestionsAnswered.clear();
  }

  bool allSurveyOK(){
    bool result = false;

    if (this._allQuestionsAnswered.isEmpty) {
      //print('No ha responsido nada');
      this._descriptionErrorInSurvey = label_content_error_survey_rleppc;
    } else if (this._allQuestionsAnswered.length < this._surveyResponse.questions.length) {
      this._descriptionErrorInSurvey = label_content_error_survey_nshrleestvpf;
    }else {
      result = true;
    }

    return result;
  }
}
