
class VenuesModel {
  List<Venue> items = [];

  VenuesModel();

  VenuesModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final venueModel = new Venue.fromJson(item);
      items.add(venueModel);
    }
  }
}

class Venue {
  Venue({
    this.address,
    this.idVenue,
    this.name,
  });

  String address;
  int idVenue;
  String name;

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
    address: json["address"],
    idVenue: json["idVenue"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "idVenue": idVenue,
    "name": name,
  };
}
