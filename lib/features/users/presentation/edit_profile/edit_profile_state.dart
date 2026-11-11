import 'package:ecomind_parents/features/users/domain/user_profile.dart';

enum NameError { required, length }

class EditProfileState {
  const new({
    this.name = '',
    this.isSaving = false,
    this.saveFailed = false,
    this.savedProfile,
    this.nameError,
  });

  final String name;
  final bool isSaving;
  // The text stays in the field so the parent can try again
  final bool saveFailed;
  // Profile returned by the backend after saving; the page closes with it
  final UserProfile? savedProfile;
  final NameError? nameError;

  // The error is not kept by copyWith: a new change clears it
  EditProfileState copyWith({
    String? name,
    bool? isSaving,
    bool? saveFailed,
    UserProfile? savedProfile,
    NameError? nameError,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      isSaving: isSaving ?? this.isSaving,
      saveFailed: saveFailed ?? this.saveFailed,
      savedProfile: savedProfile ?? this.savedProfile,
      nameError: nameError,
    );
  }
}
