class WorkAreas {
  List<WorkArea> items = new List();

  WorkAreas();

  WorkAreas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final workArea = new WorkArea.fromJson(item);
      items.add(workArea);
    }
  }
}


class WorkArea {
  WorkArea({
    this.activeDays,
    this.bookingDatetimeEnd,
    this.bookingDatetimeStart,
    this.idVenue,
    this.idWorkAreaType,
    this.idWorkArea,
    this.name,
    this.seatingCapacityActive,
    this.seatingCapacityPercent,
    this.seatingCapacityTotal,
    this.floor,
  });

  String activeDays;
  int bookingDatetimeEnd;
  int bookingDatetimeStart;
  int idVenue;
  int idWorkAreaType;
  int idWorkArea;
  String name;
  int seatingCapacityActive;
  int seatingCapacityPercent;
  int seatingCapacityTotal;
  String floor;

  factory WorkArea.fromJson(Map<String, dynamic> json) => WorkArea(
    activeDays: json["activeDays"],
    bookingDatetimeEnd: json["bookingDatetimeEnd"],
    bookingDatetimeStart: json["bookingDatetimeStart"],
    idVenue: json["idVenue"],
    idWorkAreaType: json["idWorkAreaType"],
    idWorkArea: json["idWorkArea"],
    name: json["name"],
    seatingCapacityActive: json["seatingCapacityActive"],
    seatingCapacityPercent: json["seatingCapacityPercent"],
    seatingCapacityTotal: json["seatingCapacityTotal"],
    floor: json["floor"] == null ? null : json["floor"],
  );

  Map<String, dynamic> toJson() => {
    "activeDays": activeDays,
    "bookingDatetimeEnd": bookingDatetimeEnd,
    "bookingDatetimeStart": bookingDatetimeStart,
    "idVenue": idVenue,
    "idWorkAreaType": idWorkAreaType,
    "idWorkArea": idWorkArea,
    "name": name,
    "seatingCapacityActive": seatingCapacityActive,
    "seatingCapacityPercent": seatingCapacityPercent,
    "seatingCapacityTotal": seatingCapacityTotal,
    "floor": floor == null ? null : floor,
  };
}
