import 'package:ecomind_parents/features/users/domain/my_achievement.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

enum ProfileTab { profile, friends, family }

class ProfileState {
  const new({
    this.profile,
    this.isLoading = false,
    this.selectedTab = ProfileTab.profile,
    this.isSessionExpired = false,
    this.errorMessage,
    this.commitment,
    this.achievements = const [],
    this.isLoadingAchievements = false,
    this.achievementsFailed = false,
  });

  final UserProfile? profile;
  final bool isLoading;
  final ProfileTab selectedTab;
  // The token is no longer valid: the user must sign in again
  final bool isSessionExpired;
  final UsersError? errorMessage;
  // Personal commitment (HU-006); null until the user writes one
  final String? commitment;
  // Medals earned, read from Gamification
  final List<MyAchievement> achievements;
  final bool isLoadingAchievements;
  final bool achievementsFailed;

  // The error is not kept by copyWith: a new change clears it
  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    ProfileTab? selectedTab,
    bool? isSessionExpired,
    UsersError? errorMessage,
    String? commitment,
    List<MyAchievement>? achievements,
    bool? isLoadingAchievements,
    bool? achievementsFailed,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      isSessionExpired: isSessionExpired ?? this.isSessionExpired,
      errorMessage: errorMessage,
      commitment: commitment ?? this.commitment,
      achievements: achievements ?? this.achievements,
      isLoadingAchievements:
          isLoadingAchievements ?? this.isLoadingAchievements,
      achievementsFailed: achievementsFailed ?? this.achievementsFailed,
    );
  }
}
