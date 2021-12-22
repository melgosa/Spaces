class BackgroundColors {
  List<BackgroundColor> items = [];

  BackgroundColors();

  BackgroundColors.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final backgroundColor = new BackgroundColor.fromJson(item);
      items.add(backgroundColor);
    }
  }
}

class BackgroundColor {
  BackgroundColor({
    this.id,
    this.deepColor,
    this.lightColor,
  });

  int id;
  String deepColor;
  String lightColor;

  factory BackgroundColor.fromJson(Map<String, dynamic> json) => BackgroundColor(
    id: json["id"],
    deepColor: json["deepColor"],
    lightColor: json["lightColor"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deepColor": deepColor,
    "lightColor": lightColor,
  };
}
