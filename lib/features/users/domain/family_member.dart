import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/domain/family_role.dart';

class FamilyMember {
  // Id of the membership, used to remove the member
  final int id;
  final int userId;
  final String name;
  final FamilyRole role;
  final SocialRole socialRole;
  // True for the parent who is signed in
  final bool isCurrentUser;

  const new({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.socialRole,
    required this.isCurrentUser,
  });
}
