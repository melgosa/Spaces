import 'dart:math';
import 'dart:ui';

class WorkAreaTypes {
  List<WorkAreaType> items = [];

  WorkAreaTypes();

  WorkAreaTypes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final workAreaType = new WorkAreaType.fromJson(item);
      items.add(workAreaType);
    }
  }
}

class WorkAreaType {
  static const SALA_DE_JUNTAS = 'Sala de Juntas';
  static const ASIENTO = 'Asiento';

  static const ID_ASIENTO = 1;
  static const ID_SALA = 2;
  static const ID_COMEDOR = 3;
  static const ID_AREA_DE_FUMAR = 4;

  WorkAreaType({
    this.idCatWorkAreaType,
    this.imageUrl,
    this.label,
    this.name,
  });

  int idCatWorkAreaType;
  String imageUrl;
  String label;
  String name;

  factory WorkAreaType.fromJson(Map<String, dynamic> json) => WorkAreaType(
    idCatWorkAreaType: json["idCatWorkAreaType"],
    imageUrl: json["imageUrl"],
    label: json["label"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "idCatWorkAreaType": idCatWorkAreaType,
    "imageUrl": imageUrl,
    "label": label,
    "name": name,
  };

  Color backgroundColor(){
    List colors = [
      Color.fromRGBO(2, 143, 108, 0.7),
      Color.fromRGBO(2, 128, 144, 1),
      Color.fromRGBO(122, 56, 255, 0.7),
      Color.fromRGBO(222, 128, 100, 1),
      Color.fromRGBO(122, 143, 108, 0.7),
      Color.fromRGBO(2, 110, 200, 1),
      Color.fromRGBO(180, 123, 108, 0.7),
      Color.fromRGBO(122, 222, 222, 1),
      Color.fromRGBO(255, 60, 108, 0.7),
      Color.fromRGBO(2, 255, 144, 1)
    ];

    Random random = new Random();
    int index = 0;
    index = random.nextInt(10);

    return colors[index];

  }
}
