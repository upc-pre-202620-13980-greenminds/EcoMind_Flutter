import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/domain/user_profile_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/mappers/user_profile_mapper.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/users_request_guard.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserApi api;
  // The token and the id of the parent come from the session saved by IAM
  final SessionRepository sessionRepository;

  const new({required this.api, required this.sessionRepository});

  @override
  Future<UserProfile> getCurrentProfile() {
    return guardUsersRequest(sessionRepository, (session) async {
      final dto = await api.getUser(session.accessToken, session.accountId);
      return dto.toDomain();
    });
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    return guardUsersRequest(sessionRepository, (session) async {
      final dto = await api.updateUser(session.accessToken, profile.toDto());
      return dto.toDomain();
    });
  }
}
