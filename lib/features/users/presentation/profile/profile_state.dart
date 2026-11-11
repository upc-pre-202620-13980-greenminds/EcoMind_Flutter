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
  });

  final UserProfile? profile;
  final bool isLoading;
  final ProfileTab selectedTab;
  // The token is no longer valid: the parent must sign in again
  final bool isSessionExpired;
  final UsersError? errorMessage;

  // The error is not kept by copyWith: a new change clears it
  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    ProfileTab? selectedTab,
    bool? isSessionExpired,
    UsersError? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      isSessionExpired: isSessionExpired ?? this.isSessionExpired,
      errorMessage: errorMessage,
    );
  }
}
