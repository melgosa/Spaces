import 'dart:convert';
import 'package:meta/meta.dart';

Brazalete brazaleteFromJson(String str) => Brazalete.fromJson(json.decode(str));

String brazaleteToJson(Brazalete data) => json.encode(data.toJson());

class Brazalete {
  Brazalete({
    this.id,
    @required this.mac,
    this.name,
    this.monitoring,
    this.type,
    this.dateCreated,
    this.braceletData,
  });

  int id;
  String mac;
  String name;
  int monitoring;
  int type;
  String dateCreated;
  List<BraceletDatum> braceletData;

  factory Brazalete.fromJson(Map<String, dynamic> json) => Brazalete(
        id: json["id"],
        mac: json["mac"],
        name: json["name"],
        monitoring: json["monitoring"],
        type: json["type"],
        dateCreated: json["date_created"],
        braceletData: List<BraceletDatum>.from(
            json["bracelet_data"].map((x) => BraceletDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mac": mac,
        "name": name,
        "monitoring": monitoring,
        "type": type,
        "date_created": dateCreated,
        "bracelet_data":
            List<dynamic>.from(braceletData.map((x) => x.toJson())),
      };
}

class BraceletDatum {
  BraceletDatum({
    this.id,
    this.heartRate,
    this.oxygenRate,
    this.systolycBloodPresureRate,
    this.diastolycBloodPresureRate,
    this.respiratoryRate,
    this.temperatureRate,
    this.dateSample,
    this.dateCloseUp,
    this.braceletMacCloseUp,
  });

  int id;
  int heartRate;
  int oxygenRate;
  int systolycBloodPresureRate;
  int diastolycBloodPresureRate;
  int respiratoryRate;
  double temperatureRate;
  String dateSample;
  String dateCloseUp;
  String braceletMacCloseUp;

  factory BraceletDatum.fromJson(Map<String, dynamic> json) => BraceletDatum(
        id: json["id"],
        heartRate: json["HeartRate"],
        oxygenRate: json["OxygenRate"],
        systolycBloodPresureRate: json["SystolycBloodPresureRate"],
        diastolycBloodPresureRate: json["DiastolycBloodPresureRate"],
        respiratoryRate: json["RespiratoryRate"],
        temperatureRate: json["TemperatureRate"].toDouble(),
        dateSample: json["DateSample"],
        dateCloseUp: json["DateCloseUp"],
        braceletMacCloseUp: json["BraceletMacCloseUp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "HeartRate": heartRate,
        "OxygenRate": oxygenRate,
        "SystolycBloodPresureRate": systolycBloodPresureRate,
        "DiastolycBloodPresureRate": diastolycBloodPresureRate,
        "RespiratoryRate": respiratoryRate,
        "TemperatureRate": temperatureRate,
        "DateSample": dateSample,
        "DateCloseUp": dateCloseUp,
        "BraceletMacCloseUp": braceletMacCloseUp,
      };
}
