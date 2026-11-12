import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';

class NotificationPreferencesState {
  const new({
    this.preferences = const NotificationPreferences(),
    this.isLoading = false,
    this.saveFailed = false,
  });

  final NotificationPreferences preferences;
  final bool isLoading;
  final bool saveFailed;

  // saveFailed is not kept by copyWith: a new change clears it
  NotificationPreferencesState copyWith({
    NotificationPreferences? preferences,
    bool? isLoading,
    bool? saveFailed,
  }) {
    return NotificationPreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      saveFailed: saveFailed ?? false,
    );
  }
}
