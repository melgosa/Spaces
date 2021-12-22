

import 'package:monitor_ia/src/models/answer_model.dart';

class Question {
  Question({
    this.idCatQuestion,
    this.answers,
    this.idCatSurvey,
    this.question,
    this.ordinalPosition,
  });

  int idCatQuestion;
  List<Answer> answers;
  int idCatSurvey;
  String question;
  String ordinalPosition;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    idCatQuestion: json["idCatQuestion"],
    answers: List<Answer>.from(json["catFullResponses"].map((x) => Answer.fromJson(x))),
    idCatSurvey: json["idCatSurvey"],
    question: json["question"],
    ordinalPosition: json["ordinalPosition"],
  );

  Map<String, dynamic> toJson() => {
    "idCatQuestion": idCatQuestion,
    "catFullResponses": List<dynamic>.from(answers.map((x) => x.toJson())),
    "idCatSurvey": idCatSurvey,
    "question": question,
    "ordinalPosition": ordinalPosition,
  };
}