import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences_repository.dart';

class UpdateNotificationPreferencesUseCase {
  final NotificationPreferencesRepository repository;

  const new({required this.repository});

  Future<void> execute(NotificationPreferences preferences) {
    return repository.savePreferences(preferences);
  }
}
