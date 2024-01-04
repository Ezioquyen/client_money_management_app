class NotificationModel {
  late int id;
  String? deepLink;
  String title = "Title";
  String notificationText = "text";
  String? image;
  String? name;
  bool isRead = false;
  DateTime time = DateTime.now();
  NotificationModel({
    required this.id,
    this.deepLink,
    this.title = "Title",
    this.notificationText = "text",
    this.image,
    this.name,
    this.isRead = false,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      deepLink: json['deepLink'],
      title: json['title'] ?? "Title",
      notificationText: json['notificationText'] ?? "text",
      image: json['image'],
      name: json['name'],
      isRead: json['isRead'] ?? false,
      time: json['time'] != null ? DateTime.parse(json['time']) : DateTime.now(),
    );
  }
}
