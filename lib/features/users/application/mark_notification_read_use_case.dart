import 'package:ecomind_parents/features/users/domain/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  const new({required this.repository});

  Future<void> execute(int notificationId, String languageTag) {
    return repository.markAsRead(notificationId, languageTag);
  }
}
