import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class RemoveFamilyMemberUseCase {
  final FamilyRepository repository;

  const new({required this.repository});

  Future<Family?> execute(FamilyMember member) {
    // A parent cannot remove themselves, the same rule as the backend
    if (member.isCurrentUser) {
      throw const UsersException(UsersError.parentSelfRemoval);
    }
    return repository.removeMember(member.id);
  }
}
