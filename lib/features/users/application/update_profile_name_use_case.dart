import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/domain/user_profile_repository.dart';

class UpdateProfileNameUseCase {
  final UserProfileRepository repository;

  const new({required this.repository});

  // The backend replaces the whole profile, so the values already read are sent again
  Future<UserProfile> execute(UserProfile profile, String name) {
    return repository.updateProfile(profile.withName(name.trim()));
  }
}
