import 'package:ecomind_parents/features/users/domain/app_notification.dart';

// Every method throws a UsersException when the request fails
abstract class NotificationRepository {
  // The texts come in the language given, the newest first
  Future<List<AppNotification>> getNotifications(String languageTag);
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
}
