
import 'dart:convert';

class Seats {
  List<Seat> items = new List();

  Seats();

  Seats.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final reservaEscritoriosModel = new Seat.fromJson(item);
      items.add(reservaEscritoriosModel);
    }
  }
}

class Seat {
  Seat({
    this.idSeat,
    this.idVenue,
    this.nombreVenue,
    this.idWorkArea,
    this.nombreWorkArea,
    this.isActive,
    this.name,
    this.catSeatStatus,
  });

  int idSeat;
  int idVenue;
  String nombreVenue;
  int idWorkArea;
  String nombreWorkArea;
  int isActive;
  String name;
  CatSeatStatus catSeatStatus;

  factory Seat.fromJson(Map<String, dynamic> json) => Seat(
    idSeat: json["idSeat"],
    idVenue : json["idVenue"],
    nombreVenue : json["nombreSeat"],
    idWorkArea: json["idWorkArea"],
    nombreWorkArea : json["nombreWorkArea"],
    isActive: json["isActive"],
    name: json["name"],
    catSeatStatus: CatSeatStatus.fromJson(json["catSeatStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "idSeat": idSeat,
    "idVenue": idVenue,
    "nombreSeat": nombreVenue,
    "idWorkArea": idWorkArea,
    "nombreWorkArea": nombreWorkArea,
    "isActive": isActive,
    "name": name,
    "catSeatStatus": catSeatStatus.toJson(),
  };
}

class CatSeatStatus {
  CatSeatStatus({
    this.idCatSeatStatus,
    this.color,
    this.name,
  });

  int idCatSeatStatus;
  String color;
  String name;

  factory CatSeatStatus.fromJson(Map<String, dynamic> json) => CatSeatStatus(
    idCatSeatStatus: json["idCatSeatStatus"],
    color: json["color"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "idCatSeatStatus": idCatSeatStatus,
    "color": color,
    "name": name,
  };
}
