class NotificationDto {
  final int id;
  final String category;
  final String title;
  final String message;
  final bool read;
  final String createdAt;

  const new({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      message: json['message'],
      read: json['read'],
      createdAt: json['createdAt'],
    );
  }
}
