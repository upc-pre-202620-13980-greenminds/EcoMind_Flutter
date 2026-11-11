import 'package:ecomind_parents/features/iam/application/sign_out_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_current_profile_use_case.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_state.dart';
import 'package:flutter/material.dart';

// Shared by the Profile tab and the top bar, which shows the balances of the same profile
class ProfileViewModel extends ChangeNotifier {
  final GetCurrentProfileUseCase getCurrentProfile;
  final SignOutUseCase signOutUseCase;

  new({required this.getCurrentProfile, required this.signOutUseCase});

  ProfileState _state = ProfileState();
  ProfileState get state => _state;

  Future<void> loadProfile() async {
    _state = _state.copyWith(isLoading: true, isSessionExpired: false);
    notifyListeners();

    try {
      final profile = await getCurrentProfile.execute();
      _state = _state.copyWith(profile: profile, isLoading: false);
    } on UsersException catch (e) {
      if (e.error == UsersError.sessionExpired) {
        await signOutUseCase.execute();
        _state = ProfileState(isSessionExpired: true);
      } else {
        _state = _state.copyWith(isLoading: false, errorMessage: e.error);
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: UsersError.unknown,
      );
    }
    notifyListeners();
  }

  void selectTab(ProfileTab tab) {
    _state = _state.copyWith(selectedTab: tab);
    notifyListeners();
  }

  // Called by Edit profile, so the new name is shown without asking the backend again
  void onProfileUpdated(UserProfile profile) {
    _state = _state.copyWith(profile: profile);
    notifyListeners();
  }

  Future<void> signOut() async {
    await signOutUseCase.execute();
    // This ViewModel lives for the whole application: the next parent starts empty
    _state = ProfileState();
    notifyListeners();
  }
}
