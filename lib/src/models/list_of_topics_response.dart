
class Topics{
  List <Topic> items = [];

  Topics();

  Topics.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final topic = new Topic.fromJson(item);
      items.add(topic);
    }
  }

}

class Topic {
  Topic({
    this.topicArn,
  });

  String topicArn;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    topicArn: json["TopicArn"],
  );

  Map<String, dynamic> toJson() => {
    "TopicArn": topicArn,
  };
}
