
import 'dart:convert';

ContactTracingResponse contactTracingResponseFromJson(String str) => ContactTracingResponse.fromJson(json.decode(str));

String contactTracingResponseToJson(ContactTracingResponse data) => json.encode(data.toJson());

class ContactTracingResponse {
  ContactTracingResponse({
    this.idLocationData,
    this.idEmpresa,
    this.accuracy,
    this.altitude,
    this.heading,
    this.idUsuario,
    this.latitude,
    this.longitude,
    this.speed,
    this.speedAccuracy,
    this.time,
    this.uuid,
    this.processed,
  });

  int idLocationData;
  int idEmpresa;
  double accuracy;
  double altitude;
  double heading;
  int idUsuario;
  double latitude;
  double longitude;
  double speed;
  double speedAccuracy;
  int time;
  String uuid;
  bool processed;

  factory ContactTracingResponse.fromJson(Map<String, dynamic> json) => ContactTracingResponse(
    idLocationData: json["idLocationData"],
    idEmpresa: json["idEmpresa"],
    accuracy: json["accuracy"].toDouble(),
    altitude: json["altitude"].toDouble(),
    heading: json["heading"],
    idUsuario: json["idUsuario"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    speed: json["speed"].toDouble(),
    speedAccuracy: json["speedAccuracy"],
    time: json["time"],
    uuid: json["uuid"],
    processed: json["processed"],
  );

  Map<String, dynamic> toJson() => {
    "idLocationData": idLocationData,
    "idEmpresa": idEmpresa,
    "accuracy": accuracy,
    "altitude": altitude,
    "heading": heading,
    "idUsuario": idUsuario,
    "latitude": latitude,
    "longitude": longitude,
    "speed": speed,
    "speedAccuracy": speedAccuracy,
    "time": time,
    "uuid": uuid,
    "processed": processed,
  };
}
