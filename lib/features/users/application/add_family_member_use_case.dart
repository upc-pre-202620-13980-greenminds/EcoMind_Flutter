import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';
import 'package:ecomind_parents/features/users/domain/family_role.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class AddFamilyMemberUseCase {
  final FamilyRepository repository;

  const new({required this.repository});

  Future<Family> execute(Family family, FamilyCandidate candidate) {
    // The backend does not check the limit, so it is checked here
    if (family.isFull) {
      throw const UsersException(UsersError.familyFull);
    }
    // A parent joins as PARENT and a student as CHILD
    final role = candidate.socialRole == SocialRole.parent
        ? FamilyRole.parent
        : FamilyRole.child;
    return repository.addMember(family.id, candidate.userId, role);
  }
}
