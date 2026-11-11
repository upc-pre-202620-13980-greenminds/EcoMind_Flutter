import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/users/application/update_profile_name_use_case.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/presentation/edit_profile/edit_profile_state.dart';
import 'package:flutter/material.dart';

class EditProfileViewModel extends ChangeNotifier {
  final UpdateProfileNameUseCase updateProfileName;

  new({required this.updateProfileName});

  EditProfileState _state = EditProfileState();
  EditProfileState get state => _state;

  // The page starts the form with the name it received
  void start(String name) {
    _state = EditProfileState(name: name);
  }

  void onNameChange(String name) {
    _state = _state.copyWith(name: name, saveFailed: false);
    notifyListeners();
  }

  Future<void> save(UserProfile profile) async {
    if (_state.isSaving) {
      return;
    }

    final name = _state.name.trim();
    final NameError? nameError = name.isEmpty
        ? NameError.required
        : !PersonName.isValid(name)
        ? NameError.length
        : null;
    if (nameError != null) {
      _state = _state.copyWith(nameError: nameError);
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isSaving: true, saveFailed: false);
    notifyListeners();

    try {
      final saved = await updateProfileName.execute(profile, name);
      _state = _state.copyWith(isSaving: false, savedProfile: saved);
    } catch (e) {
      _state = _state.copyWith(isSaving: false, saveFailed: true);
    }
    notifyListeners();
  }
}
