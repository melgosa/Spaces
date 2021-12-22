// To parse this JSON data, do
//
//     final registroUsuario = registroUsuarioFromJson(jsonString);

import 'dart:convert';

RegistroUsuario registroUsuarioFromJson(String str) => RegistroUsuario.fromJson(json.decode(str));

String registroUsuarioToJson(RegistroUsuario data) => json.encode(data.toJson());

class RegistroUsuario {
  RegistroUsuario({
    this.birthdate,
    this.creationDate,
    this.email,
    this.gender,
    this.hash,
    this.idCatSource,
    this.idCatUserType,
    this.idCompany,
    this.idCredential,
    this.idUser,
    this.maternalSurname,
    this.name,
    this.password,
    this.surname,
    this.usuarioMonitor,
  });

  DateTime birthdate;
  DateTime creationDate;
  String email;
  String gender;
  String hash;
  int idCatSource;
  int idCatUserType;
  int idCompany;
  int idCredential;
  int idUser;
  String maternalSurname;
  String name;
  String password;
  String surname;
  int usuarioMonitor;

  factory RegistroUsuario.fromJson(Map<String, dynamic> json) => RegistroUsuario(
    birthdate: DateTime.parse(json["birthdate"]),
    creationDate: DateTime.parse(json["creationDate"]),
    email: json["email"],
    gender: json["gender"],
    hash: json["hash"],
    idCatSource: json["idCatSource"],
    idCatUserType: json["idCatUserType"],
    idCompany: json["idCompany"],
    idCredential: json["idCredential"],
    idUser: json["idUser"],
    maternalSurname: json["maternalSurname"],
    name: json["name"],
    password: json["password"],
    surname: json["surname"],
    usuarioMonitor: json["usuarioMonitor"],
  );

  Map<String, dynamic> toJson() => {
    "birthdate": birthdate.toIso8601String(),
    "creationDate": creationDate.toIso8601String(),
    "email": email,
    "gender": gender,
    "hash": hash,
    "idCatSource": idCatSource,
    "idCatUserType": idCatUserType,
    "idCompany": idCompany,
    "idCredential": idCredential,
    "idUser": idUser,
    "maternalSurname": maternalSurname,
    "name": name,
    "password": password,
    "surname": surname,
    "usuarioMonitor": usuarioMonitor,
  };
}
