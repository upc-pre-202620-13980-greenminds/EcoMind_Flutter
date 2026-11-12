import 'package:ecomind_parents/features/users/domain/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  const new({required this.repository});

  Future<void> execute(int notificationId) {
    return repository.markAsRead(notificationId);
  }
}
