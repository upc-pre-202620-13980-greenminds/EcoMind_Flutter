import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';

class GetInvitableFriendsUseCase {
  final FamilyRepository repository;

  const new({required this.repository});

  Future<List<FamilyCandidate>> execute() {
    return repository.getInvitableFriends();
  }
}
