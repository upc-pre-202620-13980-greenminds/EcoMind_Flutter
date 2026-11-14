import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';
import 'package:ecomind_parents/features/users/domain/family_role.dart';
import 'package:ecomind_parents/features/users/infrastructure/mappers/family_mapper.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/family_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_profile_dto.dart';
import 'package:ecomind_parents/features/users/infrastructure/users_request_guard.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyApi familyApi;
  final UserApi userApi;
  final SessionRepository sessionRepository;

  const new({
    required this.familyApi,
    required this.userApi,
    required this.sessionRepository,
  });

  @override
  Future<Family?> getMyFamily() {
    return guardUsersRequest(sessionRepository, _loadMyFamily);
  }

  @override
  Future<Family> createFamily(String name, String commitment) {
    return guardUsersRequest(sessionRepository, (session) async {
      await familyApi.createFamily(session.accessToken, name, commitment);
      return (await _loadMyFamily(session))!;
    });
  }

  @override
  Future<List<FamilyCandidate>> getInvitableFriends() {
    return guardUsersRequest(sessionRepository, (session) async {
      final token = session.accessToken;
      final me = session.accountId;

      final friends = await familyApi.getFriends(token, me);
      final friendIds = friends
          .where((friend) => friend.isAccepted)
          .map((friend) => friend.friendOf(me))
          .toSet();

      // A user can belong to only one family, so members of any family are left out
      final memberships = await familyApi.getMemberships(token);
      final idsInAFamily = memberships.map((m) => m.userId).toSet();

      final profiles = await _profilesById(token);
      final candidates = friendIds
          .where((id) => !idsInAFamily.contains(id) && profiles[id] != null)
          .map((id) {
            final profile = profiles[id]!;
            return FamilyCandidate(
              userId: id,
              name: profile.name,
              socialRole: profile.socialRole == 'PARENT'
                  ? SocialRole.parent
                  : SocialRole.student,
            );
          })
          .toList();
      candidates.sort((a, b) => a.name.compareTo(b.name));
      return candidates;
    });
  }

  @override
  Future<Family> addMember(int familyId, int userId, FamilyRole role) {
    return guardUsersRequest(sessionRepository, (session) async {
      await familyApi.addMember(
        session.accessToken,
        familyId,
        userId,
        role.toApi(),
      );
      return (await _loadMyFamily(session))!;
    });
  }

  @override
  Future<Family?> removeMember(int membershipId) {
    return guardUsersRequest(sessionRepository, (session) async {
      await familyApi.removeMember(session.accessToken, membershipId);
      return _loadMyFamily(session);
    });
  }

  Future<Family?> _loadMyFamily(Session session) async {
    final token = session.accessToken;
    final memberships = await familyApi.getMemberships(
      token,
      userId: session.accountId,
    );
    if (memberships.isEmpty) {
      return null;
    }

    final familyId = memberships.first.familyId;
    final families = await familyApi.getFamilies(token);
    final matches = families.where((family) => family.id == familyId);
    if (matches.isEmpty) {
      return null;
    }

    final profiles = await _profilesById(token);
    return matches.first.toDomain(profiles, session.accountId);
  }

  Future<Map<int, UserProfileDto>> _profilesById(String token) async {
    final profiles = await userApi.getUsers(token);
    return {for (final profile in profiles) profile.id: profile};
  }
}
