import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences_repository.dart';
import 'package:ecomind_parents/features/users/domain/notification_repository.dart';
import 'package:ecomind_parents/features/users/domain/user_profile_repository.dart';

class GetVisibleNotificationsUseCase {
  final NotificationRepository notificationRepository;
  final NotificationPreferencesRepository preferencesRepository;
  // The role decides which categories exist for the user
  final UserProfileRepository profileRepository;

  const new({
    required this.notificationRepository,
    required this.preferencesRepository,
    required this.profileRepository,
  });

  // HU-018: the inbox only shows the categories the user left on,
  // so a parent can receive only the community events
  Future<List<AppNotification>> execute(String languageTag) async {
    final notifications = await notificationRepository.getNotifications(
      languageTag,
    );
    final preferences = await preferencesRepository.getPreferences();
    final profile = await profileRepository.getCurrentProfile();
    return notifications
        .where(
          (notification) =>
              preferences.allows(notification.category, profile.socialRole),
        )
        .toList();
  }
}
