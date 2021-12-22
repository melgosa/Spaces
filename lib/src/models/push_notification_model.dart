

class PushNotification {
  PushNotification({
    this.id,
    this.title,
    this.contenido,
    this.prioridad,
    this.fechaDeEnvio,
    this.fechaDeEntrega,
  });

  int id;
  String title;
  String contenido;
  String prioridad;
  String fechaDeEnvio;
  String fechaDeEntrega;

  factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification(
    id: json["id"],
    title: json["title"],
    contenido: json["contenido"],
    prioridad: json["prioridad"],
    fechaDeEnvio: json["fechaDeEnvio"],
    fechaDeEntrega: json["fechaDeEntrega"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "contenido": contenido,
    "prioridad": prioridad,
    "fechaDeEnvio": fechaDeEnvio,
    "fechaDeEntrega": fechaDeEntrega,
  };
}
