class SurveysByEmpresa{
  List <SurveyByEmpresaResponse> items = [];

  SurveysByEmpresa();

  SurveysByEmpresa.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final surveyByEmpresa = new SurveyByEmpresaResponse.fromJson(item);
      items.add(surveyByEmpresa);
    }
  }

}

class SurveyByEmpresaResponse {
  SurveyByEmpresaResponse({
    this.idSurvey,
    this.survey,
    this.status,
    this.idCatCompany
  });

  int idSurvey;
  String survey;
  int status;
  int idCatCompany;

  factory SurveyByEmpresaResponse.fromJson(Map<String, dynamic> json) =>
      SurveyByEmpresaResponse(
          idSurvey: json["idCatSurvey"],
          survey: json["survey"],
          status: json["status"],
          idCatCompany: json["idCatCompany"]
      );

  Map<String, dynamic> toJson() => {
    "idSurvey": idSurvey,
    "survey": survey,
    "status": status,
    "idCatCompany": idCatCompany,
  };
}