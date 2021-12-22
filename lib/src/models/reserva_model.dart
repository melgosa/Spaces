class Reservas {
  List<Reserva> items = [];

  Reservas();

  Reservas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final reserva = new Reserva.fromJson(item);
      items.add(reserva);
    }
  }
}

class Reserva {
  Reserva({
    this.idUser,
    this.idVenue,
    this.idWorkArea,
    this.idRoomSeat,
    this.nameRoomSeat,
    this.nameWa,
    this.bookingListRespObj,
    this.tipo,
  });

  int idUser;
  int idVenue;
  dynamic idWorkArea;
  int idRoomSeat;
  String nameRoomSeat;
  dynamic nameWa;
  List<BookingListRespObj> bookingListRespObj;
  int tipo;

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
    idUser: json["idUser"],
    idVenue: json["idVenue"],
    idWorkArea: json["idWorkArea"],
    idRoomSeat: json["idRoomSeat"],
    nameRoomSeat: json["nameRoomSeat"],
    nameWa: json["nameWA"],
    bookingListRespObj: List<BookingListRespObj>.from(json["bookingListRespObj"].map((x) => BookingListRespObj.fromJson(x))),
    tipo: json["tipo"],
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "idVenue": idVenue,
    "idWorkArea": idWorkArea,
    "idRoomSeat": idRoomSeat,
    "nameRoomSeat": nameRoomSeat,
    "nameWA": nameWa,
    "bookingListRespObj": List<dynamic>.from(bookingListRespObj.map((x) => x.toJson())),
    "tipo": tipo,
  };
}

class BookingListRespObj {
  BookingListRespObj({
    this.idReserv,
    this.bookingDateTimeStart,
    this.bookingDateTimeEnd,
    this.available,
  });

  int idReserv;
  int bookingDateTimeStart;
  int bookingDateTimeEnd;
  dynamic available;

  factory BookingListRespObj.fromJson(Map<String, dynamic> json) => BookingListRespObj(
    idReserv: json["idReserv"],
    bookingDateTimeStart: json["bookingDateTimeStart"],
    bookingDateTimeEnd: json["bookingDateTimeEnd"],
    available: json["available"],
  );

  Map<String, dynamic> toJson() => {
    "idReserv": idReserv,
    "bookingDateTimeStart": bookingDateTimeStart,
    "bookingDateTimeEnd": bookingDateTimeEnd,
    "available": available,
  };
}
