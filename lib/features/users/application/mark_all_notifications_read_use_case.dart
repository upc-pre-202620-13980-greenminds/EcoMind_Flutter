import 'package:ecomind_parents/features/users/domain/notification_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;

  const new({required this.repository});

  Future<void> execute() {
    return repository.markAllAsRead();
  }
}
