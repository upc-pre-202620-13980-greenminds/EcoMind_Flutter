import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences_repository.dart';
import 'package:ecomind_parents/features/users/domain/notification_repository.dart';

class GetVisibleNotificationsUseCase {
  final NotificationRepository notificationRepository;
  final NotificationPreferencesRepository preferencesRepository;

  const new({
    required this.notificationRepository,
    required this.preferencesRepository,
  });

  // HU-018: the inbox only shows the categories the parent left on,
  // so a parent can receive only the community events
  Future<List<AppNotification>> execute(String languageTag) async {
    final notifications = await notificationRepository.getNotifications(
      languageTag,
    );
    final preferences = await preferencesRepository.getPreferences();
    return notifications
        .where((notification) => preferences.allows(notification.category))
        .toList();
  }
}
