import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/family_role.dart';

// Every method throws a UsersException when the request fails.
// The changes return the family as it is after them.
abstract class FamilyRepository {
  // Null when the parent does not belong to a family yet
  Future<Family?> getMyFamily();
  Future<Family> createFamily(String name, String commitment);
  Future<List<FamilyCandidate>> getInvitableFriends();
  Future<Family> addMember(int familyId, int userId, FamilyRole role);
  Future<Family?> removeMember(int membershipId);
}
