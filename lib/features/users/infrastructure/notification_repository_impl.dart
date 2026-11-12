import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/notification_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/mappers/notification_mapper.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/notification_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/users_request_guard.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi api;
  final SessionRepository sessionRepository;

  const new({required this.api, required this.sessionRepository});

  @override
  Future<List<AppNotification>> getNotifications(String languageTag) {
    return guardUsersRequest(sessionRepository, (session) async {
      final dtos = await api.getNotifications(session.accessToken, languageTag);
      return dtos.map((dto) => dto.toDomain()).toList();
    });
  }

  @override
  Future<void> markAsRead(int notificationId) {
    return guardUsersRequest(
      sessionRepository,
      (session) => api.markAsRead(session.accessToken, notificationId),
    );
  }

  @override
  Future<void> markAllAsRead() {
    return guardUsersRequest(
      sessionRepository,
      (session) => api.markAllAsRead(session.accessToken),
    );
  }
}
