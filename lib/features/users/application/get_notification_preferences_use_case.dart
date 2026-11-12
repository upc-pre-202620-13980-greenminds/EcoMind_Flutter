import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences_repository.dart';

class GetNotificationPreferencesUseCase {
  final NotificationPreferencesRepository repository;

  const new({required this.repository});

  Future<NotificationPreferences> execute() {
    return repository.getPreferences();
  }
}
