import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';

class NotificationPreferencesState {
  const new({
    this.preferences = const NotificationPreferences(),
    this.isLoading = false,
    this.saveFailed = false,
    this.isStudent = false,
  });

  final NotificationPreferences preferences;
  final bool isLoading;
  final bool saveFailed;
  // A student sees the six categories of frame 70; a parent, the four of frame 83
  final bool isStudent;

  // saveFailed is not kept by copyWith: a new change clears it
  NotificationPreferencesState copyWith({
    NotificationPreferences? preferences,
    bool? isLoading,
    bool? saveFailed,
    bool? isStudent,
  }) {
    return NotificationPreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      saveFailed: saveFailed ?? false,
      isStudent: isStudent ?? this.isStudent,
    );
  }
}
