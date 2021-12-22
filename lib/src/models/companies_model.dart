import 'dart:convert';

class Companies {
  List<Company> items = List();

  Companies();

  Companies.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final company = new Company.fromJson(item);
      items.add(company);
    }
  }
}

class Company {
  Company({
    this.idCatCompany,
    this.abreviation,
    this.backgroundUrl,
    this.description,
    this.imageUrl,
    this.name,
  });

  int idCatCompany;
  String abreviation;
  String backgroundUrl;
  String description;
  String imageUrl;
  String name;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    idCatCompany: json["idCatCompany"],
    abreviation: json["abreviation"] == null ? null : json["abreviation"],
    backgroundUrl: json["background_url"] == null ? null : json["background_url"],
    description: json["description"] == null ? null : json["description"],
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "idCatCompany": idCatCompany,
    "abreviation": abreviation == null ? null : abreviation,
    "background_url": backgroundUrl == null ? null : backgroundUrl,
    "description": description == null ? null : description,
    "imageUrl": imageUrl == null ? null : imageUrl,
    "name": name,
  };
}
