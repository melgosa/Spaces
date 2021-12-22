import 'dart:convert';

StatusSeatModel statusSeatModelFromJson(String str) => StatusSeatModel.fromJson(json.decode(str));

String StatusSeatModelToJson(StatusSeatModel data) => json.encode(data.toJson());

class StatusSeatModel{

  int idCatSeatStatus;
  String color;
  String name;

  StatusSeatModel({
    this.idCatSeatStatus,
    this.color,
    this.name,
});

  factory StatusSeatModel.fromJson(Map<String, dynamic> json) => StatusSeatModel(
    idCatSeatStatus : json['idCatSeatStatus'],
    color : json['color'],
    name : json['name'],
  );

  Map<String, dynamic> toJson() => {
    'idCatSeatStatus':idCatSeatStatus.toString(),
    'color':color.toString(),
    'name':name.toString(),
  };

}