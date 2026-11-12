import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';

// The backend does not store these preferences, so they live on the device
abstract class NotificationPreferencesRepository {
  Future<NotificationPreferences> getPreferences();
  Future<void> savePreferences(NotificationPreferences preferences);
}
