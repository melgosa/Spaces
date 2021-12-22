
class Answer {
  Answer({
    this.idCatResponse,
    this.idCatQuestion,
    this.idCatResponseType,
    this.response,
  });

  int idCatResponse;
  int idCatQuestion;
  int idCatResponseType;
  String response;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    idCatResponse: json["idCatResponse"],
    idCatQuestion: json["idCatQuestion"],
    idCatResponseType: json["idCatResponseType"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "idCatResponse": idCatResponse,
    "idCatQuestion": idCatQuestion,
    "idCatResponseType": idCatResponseType,
    "response": response,
  };
}