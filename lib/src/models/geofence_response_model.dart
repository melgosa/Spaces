
class Geofences{
  List <Geofence> items = [];

  Geofences();

  Geofences.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final geofence = new Geofence.fromJson(item);
      items.add(geofence);
    }
  }

}

class Geofence {
  Geofence({
    this.id,
    this.idEmpresa,
    this.descripcion,
    this.strGeometry,
    this.polygon,
    this.estatus,
  });

  int id;
  int idEmpresa;
  String descripcion;
  String strGeometry;
  Polygon polygon;
  int estatus;

  factory Geofence.fromJson(Map<String, dynamic> json) => Geofence(
    id: json["id"],
    idEmpresa: json["idEmpresa"],
    descripcion: json["descripcion"],
    strGeometry: json["strGeometry"],
    polygon: Polygon.fromJson(json["polygon"]),
    estatus: json["estatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idEmpresa": idEmpresa,
    "descripcion": descripcion,
    "strGeometry": strGeometry,
    "polygon": polygon.toJson(),
    "estatus": estatus,
  };
}

class Polygon {
  Polygon({
    this.points,
  });

  List<Point> points;

  factory Polygon.fromJson(Map<String, dynamic> json) => Polygon(
    points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "points": List<dynamic>.from(points.map((x) => x.toJson())),
  };
}

class Point {
  Point({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
