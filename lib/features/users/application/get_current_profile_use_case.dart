import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/domain/user_profile_repository.dart';

class GetCurrentProfileUseCase {
  final UserProfileRepository repository;

  const new({required this.repository});

  Future<UserProfile> execute() {
    return repository.getCurrentProfile();
  }
}
