
class MeetingRooms {
  List<MeetingRoom> items = new List();

  MeetingRooms();

  MeetingRooms.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final meetingRoomController = new MeetingRoom.fromJson(item);
      items.add(meetingRoomController);
    }
  }
}

class MeetingRoom{
  MeetingRoom({
    this.activeDays,
    this.activeHours,
    this.activeSeats,
    this.idMeetingRoom,
    this.idVenue,
    this.nameVenue,
    this.name,
    this.totalSeats,
    this.idCatWorkAreaType
  });

  String activeDays;
  String activeHours;
  int activeSeats;
  int idMeetingRoom;
  int idVenue;
  String nameVenue;
  String name;
  int totalSeats;
  int idCatWorkAreaType;

  factory MeetingRoom.fromJson(Map<String, dynamic> json) => MeetingRoom(
    activeDays: json["activeDays"],
    activeHours: json["activeHours"],
    activeSeats: json["activeSeats"],
    idMeetingRoom: json["idMeetingRoom"],
    idVenue: json["idVenue"],
    nameVenue : json["nameVenue"],
    name: json["name"],
    totalSeats: json["totalSeats"],
    idCatWorkAreaType: json["idCatWorkAreaType"],
  );

  Map<String, dynamic> toJson() => {
    "activeDays": activeDays,
    "activeHours": activeHours,
    "activeSeats": activeSeats,
    "idMeetingRoom": idMeetingRoom,
    "idVenue": idVenue,
    "nameVenue": nameVenue,
    "name": name,
    "totalSeats": totalSeats,
    "idCatWorkAreaType": idCatWorkAreaType,
  };
}
