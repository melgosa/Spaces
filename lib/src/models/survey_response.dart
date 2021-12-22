// To parse this JSON data, do
//
//     final surveyResponse = surveyResponseFromJson(jsonString);

import 'dart:convert';

import 'package:monitor_ia/src/models/question_model.dart';

SurveyResponse surveyResponseFromJson(String str) => SurveyResponse.fromJson(json.decode(str));

String surveyResponseToJson(SurveyResponse data) => json.encode(data.toJson());

class SurveyResponse {
  SurveyResponse({
    this.idSurvey,
    this.survey,
    this.status,
    this.catCompany,
    this.questions,
  });

  int idSurvey;
  String survey;
  int status;
  CatCompany catCompany;
  List<Question> questions;

  factory SurveyResponse.fromJson(Map<String, dynamic> json) => SurveyResponse(
    idSurvey: json["idSurvey"],
    survey: json["survey"],
    status: json["status"],
    catCompany: CatCompany.fromJson(json["catCompany"]),
    questions: List<Question>.from(json["catFullQuestions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "idSurvey": idSurvey,
    "survey": survey,
    "status": status,
    "catCompany": catCompany.toJson(),
    "catFullQuestions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class CatCompany {
  CatCompany({
    this.idCatCompany,
    this.name,
    this.description,
    this.abreviation,
    this.imageUrl,
    this.backgroundUrl,
    this.timezoneName,
    this.googleApiKey,
    this.idCountry,
    this.status,
  });

  int idCatCompany;
  String name;
  String description;
  String abreviation;
  dynamic imageUrl;
  dynamic backgroundUrl;
  String timezoneName;
  String googleApiKey;
  int idCountry;
  int status;

  factory CatCompany.fromJson(Map<String, dynamic> json) => CatCompany(
    idCatCompany: json["idCatCompany"],
    name: json["name"],
    description: json["description"],
    abreviation: json["abreviation"],
    imageUrl: json["imageUrl"],
    backgroundUrl: json["background_url"],
    timezoneName: json["timezoneName"],
    googleApiKey: json["googleApiKey"],
    idCountry: json["idCountry"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "idCatCompany": idCatCompany,
    "name": name,
    "description": description,
    "abreviation": abreviation,
    "imageUrl": imageUrl,
    "background_url": backgroundUrl,
    "timezoneName": timezoneName,
    "googleApiKey": googleApiKey,
    "idCountry": idCountry,
    "status": status,
  };
}




