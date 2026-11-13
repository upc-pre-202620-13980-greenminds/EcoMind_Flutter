import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/application/get_current_profile_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_notification_preferences_use_case.dart';
import 'package:ecomind_parents/features/users/application/update_notification_preferences_use_case.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';
import 'package:ecomind_parents/features/users/presentation/notification_preferences/notification_preferences_state.dart';
import 'package:flutter/material.dart';

class NotificationPreferencesViewModel extends ChangeNotifier {
  final GetNotificationPreferencesUseCase getPreferences;
  final UpdateNotificationPreferencesUseCase updatePreferences;
  final GetCurrentProfileUseCase getCurrentProfile;

  new({
    required this.getPreferences,
    required this.updatePreferences,
    required this.getCurrentProfile,
  });

  NotificationPreferencesState _state = NotificationPreferencesState();
  NotificationPreferencesState get state => _state;

  Future<void> loadPreferences() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final preferences = await getPreferences.execute();
      _state = _state.copyWith(preferences: preferences, isLoading: false);
    } catch (e) {
      // Without the saved values every category stays on, which is the default
      _state = _state.copyWith(isLoading: false);
    }
    try {
      final profile = await getCurrentProfile.execute();
      _state = _state.copyWith(
        isStudent: profile.socialRole == SocialRole.student,
      );
    } catch (e) {
      // Without the profile only the four categories that every user has are shown
    }
    notifyListeners();
  }

  // Each switch saves at once; if saving fails it goes back
  Future<void> update(NotificationPreferences preferences) async {
    final previous = _state.preferences;
    _state = _state.copyWith(preferences: preferences);
    notifyListeners();

    try {
      await updatePreferences.execute(preferences);
    } catch (e) {
      _state = _state.copyWith(preferences: previous, saveFailed: true);
      notifyListeners();
    }
  }
}
