import 'package:ecomind_parents/features/users/domain/notification_category.dart';
import 'package:ecomind_parents/features/users/domain/notification_type.dart';

// "App" avoids a clash with the Notification class of Flutter
class AppNotification {
  final int id;
  final NotificationCategory category;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final NotificationType type;

  const new({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.type = NotificationType.unknown,
  });

  AppNotification markedAsRead() {
    return AppNotification(
      id: id,
      category: category,
      title: title,
      message: message,
      isRead: true,
      createdAt: createdAt,
      type: type,
    );
  }
}
