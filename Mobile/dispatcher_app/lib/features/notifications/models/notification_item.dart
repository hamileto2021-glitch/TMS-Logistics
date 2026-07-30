class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json["id"],
      title: json["title"],
      message: json["message"],
      type: json["type"],
      createdAt: DateTime.parse(json["createdAt"]),
      isRead: json["isRead"],
    );
  }
}